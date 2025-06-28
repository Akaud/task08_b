resource "random_string" "redis_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()_-=+[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "redis_password_secret" {
  name         = var.redis_password_secret_name
  value        = random_string.redis_password.result
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

resource "azurerm_container_group" "redis_aci" {
  name                = var.aci_name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  os_type             = "Linux"
  tags                = var.tags
  dns_name_label      = format("%s-dns", var.aci_name)

  container {
    name   = "redis"
    image  = "mcr.microsoft.com/cbl-mariner/base/redis:6.2"
    cpu    = 1
    memory = 1.5

    ports {
      port     = 6379
      protocol = "TCP"
    }

    commands = [
      "redis-server",
      "--protected-mode", "no",
      "--requirepass", azurerm_key_vault_secret.redis_password_secret.value
    ]

  }


  depends_on = [azurerm_key_vault_secret.redis_password_secret]
}

resource "azurerm_key_vault_secret" "redis_hostname_secret" {
  name         = var.redis_hostname_secret_name
  value        = azurerm_container_group.redis_aci.fqdn
  key_vault_id = var.key_vault_id
  tags         = var.tags
  depends_on   = [azurerm_container_group.redis_aci]
}
