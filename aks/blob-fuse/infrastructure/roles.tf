resource "azurerm_role_assignment" "storage_contributor" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Account Contributor"
  principal_id                     = azurerm_user_assigned_identity.app_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "storage_blob_contributor" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = azurerm_user_assigned_identity.app_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "storage_blob_contributor_current_user" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "storage_contributor_kubelet" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Account Contributor"
  principal_id                     = data.azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "storage_blob_contributor_kubelet" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     =  data.azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}