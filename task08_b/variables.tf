variable "redis_aci_sku" {
  description = "Redis ACI SKU"
  type        = string
}

variable "sa_replication_type" {
  type        = string
  description = "Replication Type of Storage Account"
}

variable "sa_container_name" {
  type        = string
  description = "Storage Account container name"
}

variable "container_acess_type" {
  type        = string
  description = "Container Acess type"
}

variable "keyvault_sku" {
  type        = string
  description = "SKU of KeyVault"
}

variable "redis_password" {
  type        = string
  description = "Secret name for redis password"
  sensitive   = true
}

variable "redis_hostname" {
  type        = string
  description = "Secret name for redis hostname"
}

variable "acr_sku" {
  type        = string
  description = "SKU of Azure Container Registry"
}

variable "image_name" {
  type        = string
  description = "Docker image name"
}

variable "aca_env_workload_profile_type" {
  type        = string
  description = "Workload profile type for Azure Container App Environment (ACAE)"
}

variable "aca_workload_profile_type" {
  type        = string
  description = "Workload profile type for ACA"
}

variable "aks_node_pool_name" {
  type        = string
  description = "Default node pool name"
}

variable "aks_node_pool_count" {
  type        = number
  description = "Default node pool instance count"
}

variable "aks_node_pool_size" {
  type        = string
  description = "Default node pool instance node size"
}

variable "aks_node_pool_disk_type" {
  type        = string
  description = "Default node pool os disk type"
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
}

variable "resources_name_prefix" {
  type        = string
  description = "Name prefix for resources"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources will be deployed."
}

variable "app_source_directory" {
  type        = string
  description = "Path to app directory"
}

variable "sa_tier" {
  type        = string
  description = "Storage Account tier"
}