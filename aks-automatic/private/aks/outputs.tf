output "AKS_RESOURCE_GROUP" {
  value     = azurerm_resource_group.aks.name
  sensitive = false
}

output "AKS_NODE_RG_NAME" {
  value     = local.aks_node_rg_name
  sensitive = true
}

output "AKS_CLUSTER_NAME" {
  value     = azapi_resource.aks.name
  sensitive = false
}

output "AKS_CLUSTER_ID" {
  value     = azapi_resource.aks.id
  sensitive = false
}

output "AKS_OIDC_ISSUER_URL" {
  value     = data.azurerm_kubernetes_cluster.this.oidc_issuer_url
  sensitive = false
}
