variable "resource_group_name" {
  description = "The name of the resource group where the Storage Account will be deployed."
  type        = string
}

variable "location" {
  description = "The Azure region where the Storage Account will be deployed."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the Azure Storage Account."
  type        = string
}

variable "storage_container_name" {
  description = "The name of the blob container within the Storage Account."
  type        = string
}

variable "source_content_path" {
  description = "The local path to the directory containing the application content to be archived."
  type        = string
}

variable "archive_filename" {
  description = "The name of the archived .tar.gz file that will be uploaded."
  type        = string
  default     = "application.tar.gz"
}

variable "storage_account_tier" {
  description = "The tier of the Storage Account."
  type        = string
}

variable "storage_account_replication_type" {
  description = "The replication type for the Storage Account."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}
