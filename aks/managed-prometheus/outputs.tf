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

output "AKS_CLUSTER_ID" {
    value = module.aks_cluster.AKS_CLUSTER_ID
    sensitive = false
}

output "WORKLOAD_ID_NAME" {
    value = azurerm_user_assigned_identity.app_identity.name
    sensitive = false
}

output "WORKLOAD_ID_CLIENT_ID" {
    value = azurerm_user_assigned_identity.app_identity.client_id
    sensitive = false
}

output "WORKLOAD_ID_TENANT_ID" {
    value = azurerm_user_assigned_identity.app_identity.tenant_id
    sensitive = false
}

output "APP_INSIGHTS_CONNECTION_STRING" {
    value = data.azurerm_application_insights.this.connection_string
    sensitive = true 
}