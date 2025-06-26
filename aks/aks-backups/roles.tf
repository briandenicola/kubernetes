

resource "azurerm_role_assignment" "aks_backup_ext_id_role_storage_blob_contributor" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = azurerm_kubernetes_cluster_extension.backups.aks_assigned_identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "cluster_id_role_contributor" {
  scope                            = azurerm_resource_group.this.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.cluster_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "dvp_role_aks_reader" {
  scope                            = module.cluster.AKS_CLUSTER_ID #data.azurerm_kubernetes_cluster.this.id
  role_definition_name             = "Reader"
  principal_id                     = azurerm_data_protection_backup_vault.this.identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "dvp_role_rg_contributor" {
  scope                            = azurerm_resource_group.this.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_data_protection_backup_vault.this.identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "dvp_role_blob_data_contributor" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = azurerm_data_protection_backup_vault.this.identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "dvp_role_snapshot_contributor" {
  scope                            = azurerm_resource_group.this.id
  role_definition_name             = "Disk Snapshot Contributor"
  principal_id                     = azurerm_data_protection_backup_vault.this.identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "dvp_role_snapshot_operator" {
  scope                            = azurerm_resource_group.this.id
  role_definition_name             = "Data Operator for Managed Disks"
  principal_id                     = azurerm_data_protection_backup_vault.this.identity.0.principal_id
  skip_service_principal_aad_check = true
}
