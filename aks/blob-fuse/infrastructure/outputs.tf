output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "AKS_RESOURCE_GROUP" {
    value = module.aks_cluster.AKS_RESOURCE_GROUP
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = module.aks_cluster.AKS_CLUSTER_NAME
    sensitive = false
}

output "ARM_WORKLOAD_APP_ID" {
    value = azurerm_user_assigned_identity.app_identity.client_id
    sensitive = false
}

output "ARM_TENANT_ID" {
    value = azurerm_user_assigned_identity.app_identity.tenant_id
    sensitive = false
}

output "APP_NAME" {
    value = local.resource_name
    sensitive = false
}

output "STORAGE_ACCOUNT_NAME" {
    value = local.storage_name
    sensitive = false
}

output "STORAGE_CONTAINER_NAME" {
    value = local.storage_container_name
    sensitive = false
}