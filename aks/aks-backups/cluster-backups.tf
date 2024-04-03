resource "azurerm_kubernetes_cluster_extension" "backups" {
  depends_on = [
    data.azurerm_kubernetes_cluster.this,
    azurerm_data_protection_backup_policy_kubernetes_cluster.this
  ]

  name              = "azure-aks-backup"
  cluster_id        = data.azurerm_kubernetes_cluster.this.id
  extension_type    = "microsoft.dataprotection.kubernetes"
  release_namespace = "dataprotection-microsoft"
  release_train     = "stable"

  configuration_settings = {
    "configuration.backupStorageLocation.config.subscriptionId"    = data.azurerm_subscription.current.subscription_id
    "configuration.backupStorageLocation.bucket"                   = local.container_name
    "configuration.backupStorageLocation.config.storageAccount"    = azurerm_storage_account.this.name
    "configuration.backupStorageLocation.config.resourceGroup"     = azurerm_storage_account.this.resource_group_name
    "configuration.backupStorageLocation.config.useAAD"            = true
    "configuration.backupStorageLocation.config.storageAccountURI" = azurerm_storage_account.this.primary_blob_endpoint
    "credentials.tenantId"                                         = data.azurerm_subscription.current.tenant_id
  }
}

