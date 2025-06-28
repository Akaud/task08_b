variable "resource_group_name" {
  description = "The name of the resource group where the ACI will be deployed."
  type        = string
}

variable "location" {
  description = "The Azure region where the ACI will be deployed."
  type        = string
}

variable "aci_name" {
  description = "The name of the Azure Container Instance group."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Azure Key Vault where the Redis password will be stored."
  type        = string
}

variable "redis_password_secret_name" {
  description = "The name of the secret in Azure Key Vault for the Redis password."
  type        = string
  default     = "redis-primary-key"
}

variable "redis_hostname_secret_name" {
  description = "The name of the secret in Azure Key Vault for the Redis hostname (IP or FQDN)."
  type        = string
  default     = "redis-hostname"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
