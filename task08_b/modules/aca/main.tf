resource "azurerm_user_assigned_identity" "aca_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.aca_name}-identity"
  tags                = var.tags
}

resource "azurerm_key_vault_access_policy" "aca_kv_secrets_access_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.aca_identity.principal_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]

  depends_on = [
    azurerm_user_assigned_identity.aca_identity,
  ]
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "aca_acr_pull_role" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aca_identity.principal_id

  depends_on = [
    azurerm_user_assigned_identity.aca_identity,
  ]
}

resource "azurerm_log_analytics_workspace" "aca_logs" {
  name                = "${var.aca_environment_name}-log-workspace"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_container_app_environment" "main_aca_environment" {
  name                       = var.aca_environment_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aca_logs.id
  tags                       = var.tags

  workload_profile {
    name                  = var.aca_workload_profile_type
    workload_profile_type = var.aca_workload_profile_type
  }

  depends_on = [
    azurerm_log_analytics_workspace.aca_logs
  ]
}

resource "azurerm_container_app" "main_aca" {
  name                         = var.aca_name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.main_aca_environment.id
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aca_identity.id]
  }
  workload_profile_name = var.aca_workload_profile_type
  secret {
    name                = "redis-url"
    key_vault_secret_id = "${var.key_vault_uri}secrets/${var.redis_hostname_secret_name}"
    identity            = azurerm_user_assigned_identity.aca_identity.id
  }
  secret {
    name                = "redis-key"
    key_vault_secret_id = "${var.key_vault_uri}secrets/${var.redis_password_secret_name}"
    identity            = azurerm_user_assigned_identity.aca_identity.id
  }

  registry {
    server   = var.acr_login_server
    identity = azurerm_user_assigned_identity.aca_identity.id
  }

  template {
    container {
      name   = "${var.aca_name}-container"
      image  = "${var.acr_login_server}/${var.image_name}:latest"
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "CREATOR"
        value = "ACA"
      }
      env {
        name  = "REDIS_PORT"
        value = 6379
      }
      env {
        name        = "REDIS_URL"
        secret_name = "redis-url"
      }
      env {
        name        = "REDIS_PWD"
        secret_name = "redis-key"
      }
    }
  }
  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_container_app_environment.main_aca_environment,
    azurerm_user_assigned_identity.aca_identity,
    azurerm_key_vault_access_policy.aca_kv_secrets_access_policy,
    azurerm_role_assignment.aca_acr_pull_role
  ]
}
