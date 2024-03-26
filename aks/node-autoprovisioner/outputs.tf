output "AKS_RESOURCE_GROUP" {
    value = local.rg_name
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = local.aks_name
    sensitive = false
}

output "AKS_CLUSTER_ID" {
    value = data.azurerm_kubernetes_cluster.this.id
    sensitive = false
}