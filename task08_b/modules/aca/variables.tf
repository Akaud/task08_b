variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the resources will be deployed."
  type        = string
}

variable "aca_environment_name" {
  description = "The name for the Azure Container App Environment."
  type        = string
}

variable "aca_name" {
  description = "The name for the Azure Container App."
  type        = string
}

variable "image_name" {
  description = "The name the Docker image."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Azure Key Vault for access policies."
  type        = string
}

variable "key_vault_uri" {
  description = "The URI of the Azure Key Vault for secret references."
  type        = string
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry for role assignments."
  type        = string
}

variable "acr_login_server" {
  description = "The login server URL of the Azure Container Registry"
  type        = string
}

variable "redis_password_secret_name" {
  description = "The name of the Key Vault secret storing the Redis password."
  type        = string
}

variable "redis_hostname_secret_name" {
  description = "The name of the Key Vault secret storing the Redis hostname (IP address)."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}
