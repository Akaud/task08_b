output "acr_id" {
  description = "The ID of the Azure Container Registry."
  value       = azurerm_container_registry.main_acr.id
}

output "acr_name" {
  description = "The name of the Azure Container Registry."
  value       = azurerm_container_registry.main_acr.name
}

output "acr_login_server" {
  description = "The login server URL of the Azure Container Registry."
  value       = azurerm_container_registry.main_acr.login_server
}

output "image_build_run_id" {
  description = "The ID of the ACR Task run triggered immediately, indicating the build pipeline is set up and initiated."
  value       = azurerm_container_registry_task_schedule_run_now.app_image_build_run_now.id
}
