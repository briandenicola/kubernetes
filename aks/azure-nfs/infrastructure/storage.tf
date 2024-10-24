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
  access_tier          = "Premium"
  enabled_protocol     = "NFS"
}

resource "azurerm_private_endpoint" "this" {
  name                = "${local.storage_name}-ep"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = data.azurerm_subnet.pe.id

  private_service_connection {
    name                           = "${local.storage_name}-ep"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.privatelink_file_core_windows_net.name
    private_dns_zone_ids = [azurerm_private_dns_zone.privatelink_file_core_windows_net.id]
  }
}