resource "azurerm_network_security_group" "this" {
  name                = "${local.resource_name}-nsg"
  location            = azurerm_resource_group.this["network"].location
  resource_group_name = azurerm_resource_group.this["network"].name

  security_rule {
    name                       = "bastion-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "168.63.129.16"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "bastion-rdp"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "168.63.129.16"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "3389"
  }
}

resource "azurerm_subnet_network_security_group_association" "api" {
  subnet_id                 = azurerm_subnet.api.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "nodes" {
  subnet_id                 = azurerm_subnet.nodes.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "private-endpoints" {
  subnet_id                 = azurerm_subnet.private-endpoints.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "compute" {
  subnet_id                 = azurerm_subnet.compute.id
  network_security_group_id = azurerm_network_security_group.this.id
}

