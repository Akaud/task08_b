variable "resource_group_name" {
  description = "The name of the resource group where the ACR will be deployed."
  type        = string
}

variable "location" {
  description = "The Azure region where the ACR will be deployed."
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry (e.g., 'Basic', 'Standard', 'Premium')."
  type        = string
}

variable "image_name" {
  description = "The name for the Docker image that will be built and pushed to ACR."
  type        = string
}

variable "app_source_blob_url" {
  description = "The full URL of the application source .tar.gz blob in Storage Account."
  type        = string
}

variable "app_source_container_sas_token" {
  description = "The Shared Access Signature (SAS) token for the application source container."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}
