output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}