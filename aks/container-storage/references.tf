data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_virtual_network" "this" {
  depends_on = [
    module.cluster
  ]
  name                = local.vnet_name
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

data "azurerm_subnet" "jumpbox" {
  depends_on = [
    data.azurerm_virtual_network.this
  ]
  name                 = local.jumpbox_subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = module.cluster.AKS_RESOURCE_GROUP
}
