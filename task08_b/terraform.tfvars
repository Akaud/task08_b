tags     = { Creator = "vladyslav_levchenko@epam.com" }
location = "East US"

app_source_directory = "./application"
redis_hostname       = "redis-hostname"
redis_password       = "redis-password"
keyvault_sku         = "standard"
acr_sku              = "Basic"
image_name           = "cmtr-pp46akvy-mod8b-app"

aca_env_workload_profile_type = "Consumption"
aca_workload_profile_type     = "Consumption"

aks_node_pool_name      = "system"
aks_node_pool_count     = 1
aks_node_pool_size      = "Standard_D2ads_v5"
aks_node_pool_disk_type = "Ephemeral"
redis_aci_sku           = "Basic"

sa_replication_type  = "LRS"
sa_container_name    = "app-content"
sa_tier              = "Standard"
container_acess_type = "private"

resources_name_prefix = "cmtr-pp46akvy-mod8b"