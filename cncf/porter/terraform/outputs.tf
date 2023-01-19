output "AKS_RESOURCE_GROUP" {
    value = azurerm_kubernetes_cluster.this.resource_group_name
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = azurerm_kubernetes_cluster.this.name
    sensitive = false
}

output "ACR_NAME" {
    value = azurerm_container_registry.this.login_server
    sensitive = false
}

output "CERTIFICATE_KV_URI" {
    value = "${azurerm_key_vault_certificate.this.versionless_id}/${azurerm_key_vault_certificate.this.version}"
    sensitive = false
}

output "APPLICATION_URI" {
    value = "api.${local.resource_name}.local"
    sensitive = false
}

output "WORKLOAD_IDENTITY" {
    value = azurerm_user_assigned_identity.whatos_service_account_identity.name
    sensitive = false
}

