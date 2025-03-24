output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this["aca"].name
    sensitive = false
}

output "VM_IP" {
    value = azurerm_network_interface.this.private_ip_address
    sensitive = false
}
