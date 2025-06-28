resource "azurerm_resource_group" "resource_group" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

module "acr" {
  source              = "./modules/acr"
  location            = var.location
  resource_group_name = local.rg_name
  acr_name            = local.acr_name
  acr_sku             = var.acr_sku
  image_name          = var.image_name
  tags                = var.tags
  git_pat             = var.git_pat
  depends_on          = [azurerm_resource_group.resource_group]
}

module "aks" {
  source                  = "./modules/aks"
  location                = var.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  tags                    = var.tags
  acr_id                  = module.acr.acr_id
  acr_login_server        = module.acr.acr_login_server
  key_vault_id            = module.keyvault.key_vault_id
  aks_name                = local.aks_name
  aks_node_pool_name      = var.aks_node_pool_name
  aks_node_pool_count     = var.aks_node_pool_count
  aks_node_pool_size      = var.aks_node_pool_size
  aks_node_pool_disk_type = var.aks_node_pool_disk_type
  depends_on              = [azurerm_resource_group.resource_group, module.keyvault, module.acr]
}

module "keyvault" {
  source              = "./modules/keyvault"
  location            = var.location
  resource_group_name = local.rg_name
  keyvault_name       = local.keyvault_name
  keyvault_sku        = var.keyvault_sku
  tags                = var.tags
  depends_on          = [azurerm_resource_group.resource_group]
}

module "redis" {
  source              = "./modules/redis"
  location            = var.location
  resource_group_name = local.rg_name
  redis_name          = local.redis_name
  redis_capacity      = var.redis_capacity
  redis_sku           = var.redis_sku
  redis_sku_family    = var.redis_sku_family
  redis_hostname      = var.redis_hostname
  redis_primary_key   = var.redis_primary_key
  tags                = var.tags
  key_vault_id        = module.keyvault.key_vault_id
  depends_on          = [azurerm_resource_group.resource_group, module.keyvault]
}

resource "kubectl_manifest" "secret_provider_class" {
  provider = kubectl.aks_cluster_context
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = module.aks.aks_node_identity_client_id
    kv_name                    = module.keyvault.keyvault_name
    redis_url_secret_name      = var.redis_hostname
    redis_password_secret_name = var.redis_primary_key
    tenant_id                  = data.azurerm_client_config.current.tenant_id
  })
  depends_on = [time_sleep.wait_for_aks_api]
}

resource "kubectl_manifest" "app_deployment" {
  provider = kubectl.aks_cluster_context
  yaml_body = templatefile("${path.module}/k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = module.acr.acr_login_server
    app_image_name   = var.image_name
    image_tag        = "latest"
  })
  depends_on = [
    kubectl_manifest.secret_provider_class,
    module.acr.azurerm_container_registry_task_schedule_run
  ]

  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
}

resource "kubectl_manifest" "app_service" {
  provider   = kubectl.aks_cluster_context
  yaml_body  = file("${path.module}/k8s-manifests/service.yaml")
  depends_on = [kubectl_manifest.app_deployment]

  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }
}

data "kubernetes_service" "app_service_lb" {
  provider = kubernetes.aks_cluster_context
  metadata {
    name = "redis-flask-app-service"
  }
  depends_on = [kubectl_manifest.app_service]
}

data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = local.aks_name
  resource_group_name = azurerm_resource_group.resource_group.name
  depends_on          = [module.aks]
}

resource "time_sleep" "wait_for_aks_api" {
  create_duration = "120s"
  depends_on      = [data.azurerm_kubernetes_cluster.aks_cluster]
}


data "azurerm_client_config" "current" {}
