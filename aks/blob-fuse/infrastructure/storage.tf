resource "azurerm_storage_account" "this" {
  name                      = local.storage_name
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  account_tier              = "Premium"
  account_replication_type  = "ZRS"
  account_kind              = "BlockBlobStorage"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  shared_access_key_enabled = false
}

resource "azurerm_storage_container" "this" {
  name                  = local.storage_container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "this" {
  name                   = "sample.txt"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  source_content         = "This is a sample text file just for testing."
}