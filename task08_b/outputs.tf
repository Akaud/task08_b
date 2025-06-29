output "redis_fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of Redis in Azure Container Instance."
  value       = module.aci_redis.aci_dns_name_fqdn
}

output "aca_fqdn" {
  description = "The FQDN of the Azure Container App."
  value       = data.azurerm_container_app.aca_actual_state.ingress[0].fqdn
  depends_on  = [data.azurerm_container_app.aca_actual_state]
}

output "aks_lb_ip" {
  description = "The Load Balancer IP address of the APP in AKS."
  value       = module.k8s.aks_lb_ip
}