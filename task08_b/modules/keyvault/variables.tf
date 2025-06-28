variable "location" {
  type        = string
  description = "The Azure region where the Key Vault will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the Key Vault will be created."
}

variable "keyvault_name" {
  type        = string
  description = "Name of the Azure Key Vault."
}

variable "keyvault_sku" {
  type        = string
  description = "SKU of the Azure Key Vault (e.g., 'standard', 'premium')."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the Key Vault resource."
}