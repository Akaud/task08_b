tags                 = { Creator = "vladyslav_levchenko@epam.com" }
location             = "East US"
container_acess_type = "private"
app_source_directory = "./application"
redis_hostname       = "redis-hostname"
redis_password       = "redis-password"
keyvault_sku         = "standard"
acr_sku              = "Basic"
image_name           = "my-flask-app"

aca_env_workload_profile_type = "Consumption"
aca_workload_profile_type     = "D4"

aks_node_pool_name      = "defaultnp"
aks_node_pool_count     = 1
aks_node_pool_size      = "Standard_B2s"
aks_node_pool_disk_type = "Managed"
redis_aci_sku           = "Basic"

sa_replication_type   = "LRS"
sa_container_name     = "app-content"
sa_tier               = "Standard"
resources_name_prefix = "vletfmprj02"