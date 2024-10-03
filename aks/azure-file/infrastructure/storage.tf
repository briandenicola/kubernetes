resource "azurerm_storage_account" "this" {
  name                      = local.storage_name
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  account_tier              = "Premium"
  account_replication_type  = "LRS"
  account_kind              = "FileStorage"
  shared_access_key_enabled = true
}

resource "azurerm_storage_share" "this" {
  name                 = local.storage_container_name
  storage_account_name = azurerm_storage_account.this.name
  quota                = 1024
}
