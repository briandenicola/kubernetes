output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "APP_URL" {
    value = azurerm_container_app.httpbin.ingress[0].fqdn
}
