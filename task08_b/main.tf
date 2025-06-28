resource "azurerm_resource_group" "resource_group" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
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

module "aci_redis" {
  source                     = "./modules/aci_redis"
  resource_group_name        = azurerm_resource_group.resource_group.name
  location                   = var.location
  aci_name                   = local.redis_aci_name
  key_vault_id               = module.keyvault.key_vault_id
  redis_password_secret_name = var.redis_password
  redis_hostname_secret_name = var.redis_hostname
  tags                       = var.tags
  depends_on                 = [module.keyvault]
}

module "storage" {
  source                           = "./modules/storage"
  resource_group_name              = azurerm_resource_group.resource_group.name
  location                         = var.location
  storage_account_name             = local.sa_name
  storage_container_name           = var.sa_container_name
  source_content_path              = var.app_source_directory
  storage_account_tier             = var.sa_tier
  storage_account_replication_type = var.sa_replication_type
  tags                             = var.tags
  depends_on                       = [azurerm_resource_group.resource_group]
}

module "acr" {
  source                         = "./modules/acr"
  resource_group_name            = azurerm_resource_group.resource_group.name
  location                       = var.location
  acr_name                       = local.acr_name
  acr_sku                        = var.acr_sku
  image_name                     = var.image_name
  app_source_blob_url            = module.storage.app_source_blob_url
  app_source_container_sas_token = module.storage.app_source_container_sas_token
  tags                           = var.tags
  depends_on = [
    azurerm_resource_group.resource_group,
    module.storage
  ]
}

module "aca" {
  source                     = "./modules/aca"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  aca_environment_name       = local.aca_env_name
  aca_name                   = local.aca_name
  image_name                 = var.image_name
  key_vault_id               = module.keyvault.key_vault_id
  key_vault_uri              = module.keyvault.key_vault_uri
  acr_id                     = module.acr.acr_id
  acr_login_server           = module.acr.acr_login_server
  redis_password_secret_name = var.redis_password
  redis_hostname_secret_name = var.redis_hostname
  tags                       = var.tags
  depends_on = [
    azurerm_resource_group.resource_group,
    module.keyvault,
    module.acr,
    module.aci_redis,
  ]
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

data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = module.aks.aks_cluster_name
  resource_group_name = azurerm_resource_group.resource_group.name
  depends_on          = [module.aks]
}


resource "time_sleep" "wait_for_aks_api" {
  create_duration = "120s"
  depends_on      = [data.azurerm_kubernetes_cluster.aks_cluster]
}


module "k8s" {
  source                      = "./modules/k8s"
  image_name                  = var.image_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  redis_hostname              = var.redis_hostname
  redis_password              = var.redis_password
  keyvault_name               = local.keyvault_name
  aks_name                    = local.aks_name
  acr_login_server            = module.acr.acr_login_server
  aks_node_identity_client_id = module.aks.aks_node_identity_client_id

  depends_on = [
    module.aks, time_sleep.wait_for_aks_api, module.acr.azurerm_container_registry_task_schedule_run
  ]

  providers = {
    kubernetes.aks_cluster_context = kubernetes.aks_cluster_context
    kubectl.aks_cluster_context    = kubectl.aks_cluster_context
  }
}

data "azurerm_client_config" "current" {}