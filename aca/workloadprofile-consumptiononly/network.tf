resource "azurerm_virtual_network" "this" {
  name                = "${local.resource_name}-network"
  address_space       = [local.vnet_cidr]
  location            = azurerm_resource_group.this["network"].location
  resource_group_name = azurerm_resource_group.this["network"].name
}
resource "azurerm_subnet" "nodes" {
  lifecycle {
    ignore_changes = [
      delegation
    ]
  }

  name                                          = "nodes"
  resource_group_name                           = azurerm_resource_group.this["network"].name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.nodes_subnet_cidir]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
}

resource "azapi_update_resource" "nodes_delegation" {
  type        = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
  resource_id = azurerm_subnet.nodes.id

  body = {
    properties = {
      delegations = [{
        name = "Microsoft.App.environment"

        properties = {
          serviceName = "Microsoft.App/environments"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        }
      }]
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
  name                                          = "private-endpoints"
  resource_group_name                           = azurerm_resource_group.this["network"].name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.pe_subnet_cidir]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet" "compute" {
  name                                          = "compute"
  resource_group_name                           = azurerm_resource_group.this["network"].name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [local.compute_subnet_cidir]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
}

resource "azurerm_network_security_group" "this" {
  name                = "${local.resource_name}-default-nsg"
  location            = azurerm_resource_group.this["network"].location
  resource_group_name = azurerm_resource_group.this["network"].name
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

