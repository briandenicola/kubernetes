output "APP_NAME" {
    value = local.resource_name
    sensitive = false
}

output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "AKS_RESOURCE_GROUP" {
    value = data.azurerm_kubernetes_cluster.this.resource_group_name
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = data.azurerm_kubernetes_cluster.this.name
    sensitive = false
}

output "ARM_WORKLOAD_APP_ID" {
    value = azurerm_user_assigned_identity.aks_pod_identity.client_id
    sensitive = false
}

output "ARM_TENANT_ID" {
    value = azurerm_user_assigned_identity.aks_pod_identity.tenant_id
    sensitive = false
}

output "APP_INSIGHTS" {
    value = data.azurerm_application_insights.this.connection_string
    sensitive = true
}

