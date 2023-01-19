output "APP_NAME" {
    value = local.resource_name
    sensitive = false
}

output "AKS_RESOURCE_GROUP" {
    value = azurerm_kubernetes_cluster.this.resource_group_name
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = azurerm_kubernetes_cluster.this.name
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