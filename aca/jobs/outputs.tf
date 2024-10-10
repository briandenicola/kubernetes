output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "JOB_NAME" {
     value = local.app_name
}