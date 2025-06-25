output "VM_PRINCIPAL_ID" {
  value     = azurerm_user_assigned_identity.this.principal_id
  sensitive = false  
}

output "VM_RESOURCE_GROUP_NAME" {
  value     = azurerm_resource_group.this.name
  sensitive = false  
}


output "VM_RESOURCE_GROUP_ID" {
  value     = azurerm_resource_group.this.id
  sensitive = false  
}
