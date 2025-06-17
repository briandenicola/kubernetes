output "AKS_RESOURCE_GROUP" {
    value = module.aks.AKS_RESOURCE_GROUP
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = module.aks.AKS_CLUSTER_NAME
    sensitive = false
}

output "AKS_CLUSTER_ID" {
    value = module.aks.AKS_CLUSTER_ID
    sensitive = false
}