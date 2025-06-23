resource "azurerm_storage_account" "this" {
  name                      = local.storage_account_name
  resource_group_name       = azurerm_resource_group.this.name
  location                  = var.region
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  https_traffic_only_enabled = true
  min_tls_version           = "TLS1_2"
}

resource "azurerm_storage_container" "this" {
  name                  = local.container_name
  storage_account_id = azurerm_storage_account.this.id
}
