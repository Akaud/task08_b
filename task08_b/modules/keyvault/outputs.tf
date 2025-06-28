output "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "The URI of the Azure Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}

output "keyvault_name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.main.name
}