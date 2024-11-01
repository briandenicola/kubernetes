output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "ARO_NAME" {
    value = local.aro_name
    sensitive = false
}