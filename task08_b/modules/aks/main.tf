resource "azurerm_user_assigned_identity" "aks_control_plane_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.aks_name}-control-plane-identity"
  tags                = var.tags
}

resource "azurerm_user_assigned_identity" "aks_node_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.aks_name}-node-identity"
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks_control_plane_to_kubelet_identity_operator" {
  scope                = azurerm_user_assigned_identity.aks_node_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks_control_plane_identity.principal_id

  depends_on = [
    azurerm_user_assigned_identity.aks_control_plane_identity,
    azurerm_user_assigned_identity.aks_node_identity
  ]
}


resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_name
  tags                = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_control_plane_identity.id]
  }

  default_node_pool {
    name            = var.aks_node_pool_name
    node_count      = var.aks_node_pool_count
    vm_size         = var.aks_node_pool_size
    os_disk_type    = var.aks_node_pool_disk_type
    os_disk_size_gb = 50
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_node_identity.client_id
    object_id                 = azurerm_user_assigned_identity.aks_node_identity.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_node_identity.id
  }

  depends_on = [
    azurerm_user_assigned_identity.aks_control_plane_identity,
    azurerm_user_assigned_identity.aks_node_identity,
    azurerm_role_assignment.aks_control_plane_to_kubelet_identity_operator
  ]
}

resource "azurerm_role_assignment" "aks_acr_pull_permission" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks_node_identity.principal_id
  depends_on = [
    azurerm_kubernetes_cluster.aks_cluster,
    azurerm_user_assigned_identity.aks_node_identity
  ]
}

resource "azurerm_key_vault_access_policy" "aks_kv_secret_access" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.aks_node_identity.principal_id
  secret_permissions = [
    "Get", "List"
  ]
  depends_on = [
    azurerm_kubernetes_cluster.aks_cluster,
    azurerm_user_assigned_identity.aks_node_identity,
  ]
}

data "azurerm_client_config" "current" {}
