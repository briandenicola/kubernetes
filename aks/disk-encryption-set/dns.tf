resource "azurerm_private_dns_zone" "aks_private_zone" {
  name                = "privatelink.${local.location}.azmk8s.io"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_private_zone" {
  name                  = "${azurerm_virtual_network.this.name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.aks_private_zone.name
  resource_group_name   = azurerm_resource_group.network.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "privatelink_vaultcore_azure_net" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_vaultcore_azure_net" {
  name                  = "${azurerm_virtual_network.this.name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
  resource_group_name   = azurerm_resource_group.network.name
  virtual_network_id    = azurerm_virtual_network.this.id
}
