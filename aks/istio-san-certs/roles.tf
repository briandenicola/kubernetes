resource "azurerm_role_assignment" "deployer_kv_access" {
  scope                            = azurerm_key_vault.this.id
  role_definition_name             = "Key Vault Administrator"
  principal_id                     = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "istio_ingress_secret_access" {
  scope                            = azurerm_key_vault.this.id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_user_assigned_identity.aks_service_mesh_identity.principal_id
  skip_service_principal_aad_check = true
}