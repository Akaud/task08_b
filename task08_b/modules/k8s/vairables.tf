variable "redis_hostname" {
  description = "The hostname for the Redis instance, used as a secret name in Key Vault."
  type        = string
}

variable "redis_password" {
  description = "The primary key for the Redis instance, used as a secret name in Key Vault."
  type        = string
}

variable "image_name" {
  description = "The name of the application image to be deployed."
  type        = string
}

variable "aks_name" {
  description = "The name of the Azure Kubernetes Service (AKS) cluster."
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID"
  type        = string
}

variable "keyvault_name" {
  description = "Name of Key Vault"
  type        = string
}

variable "aks_node_identity_client_id" {
  description = "Id of AKS node identity client"
  type        = string
}

variable "acr_login_server" {
  type        = string
  description = "The login server of the Azure Container Registry."
}

