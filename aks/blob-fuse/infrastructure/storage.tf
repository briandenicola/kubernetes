resource "azurerm_storage_account" "this" {
  name                       = local.storage_name
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  account_tier               = "Premium"
  account_replication_type   = "LRS"
  account_kind               = "BlockBlobStorage"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  shared_access_key_enabled  = true #false
}

resource "azurerm_storage_container" "this" {
  depends_on = [
    azurerm_role_assignment.storage_blob_contributor_current_user
  ]

  name                  = local.storage_container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

# resource "azurerm_storage_blob" "this" {
#   depends_on = [
#     azurerm_role_assignment.storage_blob_contributor_current_user
#   ]

#   name                   = "sample.txt"
#   storage_account_name   = azurerm_storage_account.this.name
#   storage_container_name = azurerm_storage_container.this.name
#   type                   = "Block"
#   source_content         = "This is a sample text file just for testing."
# }
