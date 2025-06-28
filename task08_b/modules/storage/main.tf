resource "azurerm_storage_account" "app_content_sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                     = var.tags
}

resource "azurerm_storage_container" "app_content_container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.app_content_sa.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.app_content_sa]
}

data "archive_file" "app_source_archive" {
  type        = "tar.gz"
  source_dir  = var.source_content_path
  output_path = "${path.module}/${var.archive_filename}"
}

resource "azurerm_storage_blob" "app_source_blob" {
  name                   = var.archive_filename
  storage_account_name   = azurerm_storage_account.app_content_sa.name
  storage_container_name = azurerm_storage_container.app_content_container.name
  type                   = "Block"
  source                 = data.archive_file.app_source_archive.output_path
  content_md5            = data.archive_file.app_source_archive.output_md5
  depends_on = [
    azurerm_storage_container.app_content_container,
    data.archive_file.app_source_archive
  ]
}

resource "time_static" "sas_start_time" {
  rfc3339 = timestamp()
}

resource "time_offset" "sas_expiry_time" {
  offset_hours = 24
  base_rfc3339 = time_static.sas_start_time.rfc3339
}

data "azurerm_storage_account_sas" "app_source_container_sas" {
  connection_string = azurerm_storage_account.app_content_sa.primary_connection_string

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  resource_types {
    service   = false
    container = true
    object    = true
  }

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = true
    add     = false
    create  = false
    process = false
    tag     = false
    update  = false
    filter  = false
  }

  start  = time_static.sas_start_time.rfc3339
  expiry = time_offset.sas_expiry_time.rfc3339

  https_only = true

  depends_on = [
    azurerm_storage_container.app_content_container,
    time_static.sas_start_time,
    time_offset.sas_expiry_time
  ]
}