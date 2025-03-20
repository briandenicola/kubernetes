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

output "ALB_IDENTITY_CLIENT_ID" {
    value = azurerm_user_assigned_identity.alb_identity.client_id
    sensitive = false
}

output "ALB_RESOURCE_ID" {
    value = azurerm_application_load_balancer.this.id
    sensitive = false
}

output "ALB_FRONTEND_NAME" {
    value = azurerm_application_load_balancer_frontend.this.name
    sensitive = false
}