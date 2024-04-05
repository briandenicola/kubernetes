resource "azurerm_network_security_group" "ml" {
  name                = "${local.aml_workspace_name}-nsg"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.name

  security_rule {
    name                       = "AllowAzureActiveDirectory80"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "80"
    destination_address_prefix = "AzureActiveDirectory"
  }

  security_rule {
    name                       = "AllowAzureActiveDirectory443"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "AzureActiveDirectory"
  }

  security_rule {
    name                       = "AllowAzureMachineLearning443"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "AzureMachineLearning"
  }

  security_rule {
    name                       = "AllowAzureMachineLearning8787"
    priority                   = 111
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "8787"
    destination_address_prefix = "AzureMachineLearning"
  }

  security_rule {
    name                       = "AllowAzureMachineLearning18881"
    priority                   = 112
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "18881"
    destination_address_prefix = "AzureMachineLearning"
  }

  security_rule {
    name                       = "AllowBatchNodeManagement"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "BatchNodeManagement.${local.location}"
  }

  security_rule {
    name                       = "AllowAzureResourceManager"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "AzureResourceManager"
  }

  security_rule {
    name                       = "AllowStorage443"
    priority                   = 140
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "Storage.${local.location}"
  }

  security_rule {
    name                       = "AllowStorage445"
    priority                   = 141
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "445"
    destination_address_prefix = "Storage.${local.location}"
  }

  security_rule {
    name                       = "AllowAzureFrontDoorFrontEnd"
    priority                   = 150
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "AzureFrontDoor.FirstParty"
  }

  security_rule {
    name                       = "AllowAzureContainerRegistry"
    priority                   = 160
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "MicrosoftContainerRegistry.${local.location}"
  }

  security_rule {
    name                       = "AllowAzureMonitor"
    priority                   = 170
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "AzureMonitor"
  }

  security_rule {
    name                       = "AllowAzureKeyvault"
    priority                   = 180
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "AzureKeyvault.${local.location}"
  }

  security_rule {
    name                       = "AllowAzureMachineLearningUDP"
    priority                   = 190
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "5831"
    destination_address_prefix = "AzureMachineLearning"
  }

  security_rule {
    name                       = "BlockAllOutbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "*"
    destination_address_prefix = "Internet"
  }

}
