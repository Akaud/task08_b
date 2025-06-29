output "aca_fqdn" {
  description = "The FQDN of the Azure Container App."
  value       = azurerm_container_app.main_aca.latest_revision_fqdn
}