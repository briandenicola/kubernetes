resource "azurerm_private_dns_zone" "privatelink_azurecr_io" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.regional_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_azurecr_io" {
  name                  = "${azurerm_virtual_network.regional_rg.name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_azurecr_io.name
  resource_group_name   = azurerm_resource_group.regional_rg.name
  virtual_network_id    = azurerm_virtual_network.regional_rg.id
}