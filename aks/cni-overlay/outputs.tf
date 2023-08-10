output "AKS_RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = local.aks_name
    sensitive = false
}
