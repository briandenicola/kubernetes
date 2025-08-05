output "RESOURCE_GROUP" {
  value     = azurerm_resource_group.this.name
  sensitive = false
}

output "AKS_CLUSTER_NAME" {
  value     = local.aks_name
  sensitive = false
}

output "AKS_CLUSTER_ID" {
  value     = azapi_resource.aks.id
  sensitive = false
}
