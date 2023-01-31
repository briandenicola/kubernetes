output "AKS_RESOURCE_GROUP" {
  value     = azurerm_kubernetes_cluster.controlplane.resource_group_name
  sensitive = false
}

output "CONTROLPLANE_AKS_CLUSTER_NAME" {
  value     = azurerm_kubernetes_cluster.controlplane.name
  sensitive = false
}

output "WORKLOAD_AKS_CLUSTER_NAME" {
  value     = azurerm_kubernetes_cluster.workload.name
  sensitive = false
}