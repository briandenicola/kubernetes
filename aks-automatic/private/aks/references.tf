data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

locals {
  vnet_rg_name = split("/", var.azurerm_virtual_network_id)[4]
  vnet_name    = split("/", var.azurerm_virtual_network_id)[8]
}

data "azurerm_subnet" "private-endpoints" {
  name                 = "private-endpoints"
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_rg_name
}

data "azurerm_subnet" "api" {
  name                 = "api-server"
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_rg_name
}

