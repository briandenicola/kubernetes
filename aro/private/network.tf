resource "azurerm_virtual_network" "this" {
  name                = "${local.resource_name}-network"
  address_space       = [local.vnet_cidr]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}


resource "azurerm_subnet" "master_subnet" {
  name                                          = "master"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.master_subnet_cidir]
  private_link_service_network_policies_enabled = false
  service_endpoints                             = ["Microsoft.ContainerRegistry"]
}

resource "azurerm_subnet" "worker_subnet" {
  name                 = "nodes"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [local.worker_subnet_cidir]
  service_endpoints    = ["Microsoft.ContainerRegistry"]
}

resource "azurerm_network_security_group" "this" {
  name                = "${local.resource_name}-default-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

# resource "azurerm_subnet_network_security_group_association" "worker_subnet" {
#   subnet_id                 = azurerm_subnet.worker_subnet.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }

# resource "azurerm_subnet_network_security_group_association" "master_subnet" {
#   subnet_id                 = azurerm_subnet.master_subnet.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }