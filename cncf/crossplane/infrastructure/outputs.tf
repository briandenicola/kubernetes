output "AKS_RESOURCE_GROUP" {
  value     = azurerm_kubernetes_cluster.controlplane.resource_group_name
  sensitive = false
}

output "CONTROLPLANE_AKS_CLUSTER_NAME" {
  value     = azurerm_kubernetes_cluster.controlplane.name
  sensitive = false
}

output "AKS_SUBSCRIPTION_ID" {
  value     = data.azurerm_client_config.current.subscription_id
  sensitive = false
}