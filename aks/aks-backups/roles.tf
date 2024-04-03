

resource "azurerm_role_assignment" "aks_backup_role_blob_data_contributor" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = azurerm_kubernetes_cluster_extension.backups.aks_assigned_identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster_trusted_access_role_binding" "this" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.backups,
    azurerm_role_assignment.aks_backup_role_blob_data_contributor
  ]
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.this.id
  name                  = "backuprolebinding"
  roles                 = [ "Microsoft.DataProtection/backupVaults/backup-operator" ]
  source_resource_id    = azurerm_data_protection_backup_vault.this.id
}

resource "azurerm_role_assignment" "aks_backup_role_reader" {
  scope                            = data.azurerm_kubernetes_cluster.this.id
  role_definition_name             = "Reader"
  principal_id                     = azurerm_kubernetes_cluster_extension.backups.aks_assigned_identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_backup_role_snapshot_readder" {
  scope                            = azurerm_resource_group.this.id
  role_definition_name             = "Reader"
  principal_id                     = azurerm_kubernetes_cluster_extension.backups.aks_assigned_identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_contributor_role" {
  scope                            = azurerm_resource_group.this.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.cluster_identity.principal_id
  skip_service_principal_aad_check = true
}

