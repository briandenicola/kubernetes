resource "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  address_space       = [local.vnet_cidr]
  location            = azurerm_resource_group.this["network"].location
  resource_group_name = azurerm_resource_group.this["network"].name
}

resource "azurerm_subnet" "nodes" {
  name                            = "nodes"
  resource_group_name             = azurerm_resource_group.this["network"].name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [local.nodes_subnet_cidir]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "api" {
  name                            = "api-server"
  resource_group_name             = azurerm_resource_group.this["network"].name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [local.api_subnet_cidir]
  default_outbound_access_enabled = false

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

resource "azurerm_subnet" "bastion" {
  name                            = "AzureBastionSubnet"
  resource_group_name             = azurerm_resource_group.this["network"].name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [local.bastion_subnet_cidir]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet" "pe" {
  name                            = "private-endpoints"
  resource_group_name             = azurerm_resource_group.this["network"].name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [local.pe_subnet_cidir]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "compute" {
  name                            = "compute"
  resource_group_name             = azurerm_resource_group.this["network"].name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [local.compute_subnet_cidir]
  default_outbound_access_enabled = false
}



