resource "azurerm_storage_account" "this" {
    name                     = "${replace(local.resource_name,"-","")}sa"
    location                 = azurerm_resource_group.this.location
    resource_group_name      = azurerm_resource_group.this.name
    account_tier             = "Standard"
    account_replication_type = "GRS"
}

resource "azurerm_private_endpoint" "blob" {
  name                = "ple-${replace(local.resource_name,"-","")}sa-blob"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.pe.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  private_service_connection {
    name                           = "psc-${local.resource_name}"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "file" {
  name                = "ple-${replace(local.resource_name,"-","")}sa-file"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.pe.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.file.id]
  }

  private_service_connection {
    name                           = "psc-${local.resource_name}"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
}