resource "azurerm_key_vault_key" "disk_encryption_key" {
  depends_on = [
    azurerm_key_vault_access_policy.az_resource_creator
  ]
  name         = "${local.aks_name}-des-key"
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

resource "azurerm_disk_encryption_set" "disk_encryption_set" {
  name                = "${local.aks_name}-enc-set"
  resource_group_name = azurerm_resource_group.this["aks"].name
  location            = azurerm_resource_group.this["aks"].location
  key_vault_key_id    = azurerm_key_vault_key.disk_encryption_key.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "disk_encryption_set_access_policy" {
  key_vault_id = azurerm_key_vault.this.id

  tenant_id = azurerm_disk_encryption_set.disk_encryption_set.identity[0].tenant_id
  object_id = azurerm_disk_encryption_set.disk_encryption_set.identity[0].principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey",
  ]
}
