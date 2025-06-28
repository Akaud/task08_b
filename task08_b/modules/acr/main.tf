resource "azurerm_container_registry" "main_acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = true
  tags                = var.tags
}

resource "time_sleep" "wait_for_acr_dns" {
  create_duration = "60s"
  depends_on      = [azurerm_container_registry.main_acr]
}

resource "azurerm_container_registry_task" "app_image_build_task" {
  name                  = "${var.acr_name}-build-task"
  container_registry_id = azurerm_container_registry.main_acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    context_path         = var.app_source_blob_url
    context_access_token = var.app_source_container_sas_token
    dockerfile_path      = "Dockerfile"
    image_names          = ["${var.image_name}:latest"]
  }
  tags = var.tags
  depends_on = [
    time_sleep.wait_for_acr_dns
  ]
}

resource "azurerm_container_registry_task_schedule_run_now" "app_image_build_run_now" {
  container_registry_task_id = azurerm_container_registry_task.app_image_build_task.id
  depends_on                 = [azurerm_container_registry_task.app_image_build_task]
}
