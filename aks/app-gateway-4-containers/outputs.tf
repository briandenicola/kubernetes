output "AKS_RESOURCE_GROUP" {
    value = module.cluster.AKS_RESOURCE_GROUP
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = module.cluster.AKS_CLUSTER_NAME
    sensitive = false
}

output "AKS_CLUSTER_ID" {
    value = module.cluster.AKS_CLUSTER_ID
    sensitive = false
}

output "APPGW_IDENITTY_CLIENT_ID" {
    value = azurerm_user_assigned_identity.alb_identity.client_id
    sensitive = false
}