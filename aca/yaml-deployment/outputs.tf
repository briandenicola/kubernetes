output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "APP_ENVIRONMENT" {
    value = data.azurerm_container_app_environment.this.name
}

output "APP_ENVIRONMENT_ID" {
    value = data.azurerm_container_app_environment.this.id
}