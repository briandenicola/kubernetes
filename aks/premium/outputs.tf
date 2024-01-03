output "AKS_RESOURCE_GROUP" {
  value     = data.azurerm_kubernetes_cluster.this.resource_group_name
  sensitive = false
}

output "AKS_CLUSTER_NAME" {
  value     = data.azurerm_kubernetes_cluster.this.name
  sensitive = false
}