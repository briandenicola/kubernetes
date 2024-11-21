
resource "azurerm_virtual_network" "regional_rg" {
  name                = local.vnet_name
  location            = azurerm_resource_group.regional_rg.location
  resource_group_name = azurerm_resource_group.regional_rg.name
  address_space       = [local.vnet_cidr]
}

resource "azurerm_subnet" "AzureFirewall" {
  name                              = "AzureFirewallSubnet"
  resource_group_name               = azurerm_resource_group.regional_rg.name
  virtual_network_name              = azurerm_virtual_network.regional_rg.name
  address_prefixes                  = [local.fw_subnet_cidir]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "private_endpoints" {
  name                              = "private_endpoints"
  resource_group_name               = azurerm_resource_group.regional_rg.name
  virtual_network_name              = azurerm_virtual_network.regional_rg.name
  address_prefixes                  = [local.pe_subnet_cidir]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "compute" {
  name                              = "nodes"
  resource_group_name               = azurerm_resource_group.regional_rg.name
  virtual_network_name              = azurerm_virtual_network.regional_rg.name
  address_prefixes                  = [local.compute_subnet_cidir]
  private_endpoint_network_policies = "Enabled"

}
