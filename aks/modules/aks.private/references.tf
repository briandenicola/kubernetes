data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azurerm_kubernetes_service_versions" "current" {
  location = local.location
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

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

