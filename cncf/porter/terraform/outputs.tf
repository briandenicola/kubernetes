output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
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

