resource "azurerm_bastion_host" "this" {
  name                = local.bastion_name
  location            = azurerm_resource_group.regional_rg.location
  resource_group_name = azurerm_resource_group.regional_rg.name
  virtual_network_id  = azurerm_virtual_network.regional_rg.id
  sku                 = "Developer"
}
