output "aci_ip_address" {
  description = "The public IP address of the Azure Container Instance hosting Redis."
  value       = azurerm_container_group.redis_aci.ip_address
}

output "aci_dns_name_fqdn" {
  description = "The fully qualified domain name (FQDN) of the Azure Container Instance hosting Redis."
  value       = azurerm_container_group.redis_aci.fqdn
}
