resource "azurerm_key_vault_key" "etcd_encryption_key" {
  depends_on = [
    azurerm_key_vault_access_policy.az_resource_creator
  ]
  name         = "${local.aks_name}-etcd-key"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_access_policy" "etcd_encryption_access_policy" {
  key_vault_id = azurerm_key_vault.this.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_user_assigned_identity.aks_identity.principal_id

  key_permissions = [
    "decrypt",
    "encrypt",
  ]
}