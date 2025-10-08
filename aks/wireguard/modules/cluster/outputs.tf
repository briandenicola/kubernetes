output "AKS_RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "AKS_NODE_RG_NAME" {
    value = local.aks_node_rg_name
    sensitive = true
}

output "AKS_CLUSTER_NAME" {
    value = var.aks_cluster.name
    sensitive = false
}

output "AKS_CLUSTER_ID" {
    value = data.azurerm_kubernetes_cluster.this.id
    sensitive = false
}

output "AKS_OIDC_ISSUER_URL" {
    value = data.azurerm_kubernetes_cluster.this.oidc_issuer_url
    sensitive = false 
}

output "VNET_ID" {
    value = azurerm_virtual_network.this.id
    sensitive = false
}

output "VNET_NAME" {
    value = azurerm_virtual_network.this.name
    sensitive = false
}

output "VNET_CIDR" {
    value = local.vnet_cidr
    sensitive = false
}