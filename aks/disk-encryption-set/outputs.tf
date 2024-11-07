output "AKS_RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
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

output "BASTION_RG" {
    value = azurerm_bastion_host.this.resource_group_name
    sensitive = false
}

output "BASTION_NAME" {
    value = azurerm_bastion_host.this.name
    sensitive = false
}

output "JUMPBOX_ID" {
    value = azurerm_linux_virtual_machine.this.id
    sensitive = false
}