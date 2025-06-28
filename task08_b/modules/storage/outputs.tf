output "storage_account_name" {
  description = "The name of the Azure Storage Account."
  value       = azurerm_storage_account.app_content_sa.name
}

output "storage_account_id" {
  description = "The ID of the Azure Storage Account."
  value       = azurerm_storage_account.app_content_sa.id
}

output "storage_container_name" {
  description = "The name of the blob container for application content."
  value       = azurerm_storage_container.app_content_container.name
}

output "app_source_blob_url" {
  description = "The URL of the application source .tar.gz blob in Storage Account (without SAS)."
  value       = azurerm_storage_blob.app_source_blob.url
}

output "app_source_container_sas_token" {
  description = "The Shared Access Signature (SAS) token for the application source container."
  value       = data.azurerm_storage_account_sas.app_source_container_sas.sas
  sensitive   = true
}
