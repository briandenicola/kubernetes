resource "azurerm_network_security_group" "this" {
  name                = "${var.app_name}-default-nsg"
  location            = azurerm_resource_group.regional_rg.location
  resource_group_name = azurerm_resource_group.regional_rg.name
}

resource "azurerm_subnet_network_security_group_association" "compute" {
  subnet_id                 = azurerm_subnet.nodes.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.this.id
}