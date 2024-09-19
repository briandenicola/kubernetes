output "AKS_RESOURCE_GROUP" {
    value = azurerm_kubernetes_cluster.this.resource_group_name
    sensitive = false
}

output "AKS_NODE_RG_NAME" {
    value = local.aks_node_rg_name
    sensitive = true
}

output "AKS_CLUSTER_NAME" {
    value = azurerm_kubernetes_cluster.this.name
    sensitive = false
}

output "AKS_CLUSTER_ID" {
    value = azurerm_kubernetes_cluster.this.id
    sensitive = false
}

output "AKS_OIDC_ISSUER_URL" {
    value = azurerm_kubernetes_cluster.this.oidc_issuer_url
    sensitive = false 
}