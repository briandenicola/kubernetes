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