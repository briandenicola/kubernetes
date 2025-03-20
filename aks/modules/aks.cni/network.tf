resource "azurerm_virtual_network" "this" {
  name                = "${var.resource_name}-network"
  address_space       = [local.vnet_cidr]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "nodes" {
  name                                          = "nodes"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.nodes_subnet_cidir]
  default_outbound_access_enabled               = true
  private_link_service_network_policies_enabled = false
}

resource "azurerm_subnet" "pe" {
  name                                          = "private-endpoints"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.pe_subnet_cidir]
  default_outbound_access_enabled               = true
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet" "compute" {
  name                                          = "compute"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.compute_subnet_cidir]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = true
}

resource "azurerm_subnet" "alb" {
  name                                          = "alb"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.alb_subnet_cidir]
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = true
  delegation {
    name = "alb-delegation"

    service_delegation {
      name = "Microsoft.ServiceNetworking/trafficControllers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_network_security_group" "this" {
  name                = "${var.resource_name}-default-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "allow-http-my-ipaddress"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = local.home_ip_address
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "allow-https-my-ipaddress"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = local.home_ip_address
    destination_address_prefix = "*"
  }  
}

resource "azurerm_network_security_group" "alb" {
  name                = "${var.resource_name}-alb-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "nodes" {
  subnet_id                 = azurerm_subnet.nodes.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "compute" {
  subnet_id                 = azurerm_subnet.compute.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "alb" {
  subnet_id                 = azurerm_subnet.alb.id
  network_security_group_id = azurerm_network_security_group.alb.id
}
