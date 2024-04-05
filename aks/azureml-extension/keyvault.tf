resource "azurerm_key_vault" "this" {
  name                = local.key_vault_name
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_private_endpoint" "kv" {
  name                = "ple-${local.key_vault_name}"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.pe.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.vault.id]
  }

  private_service_connection {
    name                           = "psc-${local.resource_name}"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
