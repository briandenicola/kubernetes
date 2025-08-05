resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  address_space       = [local.vnet_cidr]
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
}

resource "azurerm_subnet" "nodes" {
  name                            = "nodes"
  resource_group_name             = azurerm_resource_group.aks.name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [local.nodes_subnet_cidir]
  default_outbound_access_enabled = false

}

resource "azurerm_subnet" "api" {
  name                            = "api-server"
  resource_group_name             = azurerm_resource_group.aks.name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [local.api_subnet_cidir]
 
  delegation {
    name = "aks-delegation"

    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "pe" {
  name                            = "private-endpoints"
  resource_group_name             = azurerm_resource_group.aks.name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [local.pe_subnet_cidir]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "compute" {
  name                                          = "compute"
  resource_group_name                           = azurerm_resource_group.aks.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.compute_subnet_cidir]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

resource "azurerm_network_security_group" "this" {
  name                = local.nsg_name
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
}

resource "azurerm_subnet_network_security_group_association" "nodes" {
  subnet_id                 = azurerm_subnet.nodes.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "api" {
  subnet_id                 = azurerm_subnet.api.id
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