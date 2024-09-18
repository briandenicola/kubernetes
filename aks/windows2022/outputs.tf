output "AKS_RESOURCE_GROUP" {
    value = module.aks_cluster.AKS_RESOURCE_GROUP
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = module.aks_cluster.AKS_CLUSTER_NAME
    sensitive = false
}

output "AKS_CLUSTER_ID" {
    value = module.aks_cluster.AKS_CLUSTER_ID
    sensitive = false
}