variable "location" {
  type        = string
  description = "The Azure region where the AKS cluster will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the AKS cluster will be deployed."
}

variable "tags" {
  description = "A map of tags to assign to the AKS cluster and associated resources."
  type        = map(string)
}

variable "aks_name" {
  type        = string
  description = "Name of the Azure Kubernetes Service cluster."
}

variable "aks_node_pool_name" {
  type        = string
  description = "Name of the default node pool for the AKS cluster."
}

variable "aks_node_pool_count" {
  type        = number
  description = "Number of instances in the default node pool."
}

variable "aks_node_pool_size" {
  type        = string
  description = "VM size for nodes in the default node pool."
}

variable "aks_node_pool_disk_type" {
  type        = string
  description = "OS disk type for nodes in the default node pool."
}

variable "acr_id" {
  type        = string
  description = "The ID of the Azure Container Registry to grant pull permissions to."
}

variable "acr_login_server" {
  type        = string
  description = "The login server of the Azure Container Registry."
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Azure Key Vault to grant secret access to."
}
