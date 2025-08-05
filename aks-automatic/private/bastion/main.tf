resource "azurerm_bastion_host" "this" {
  name                = var.bastion_host.name
  location            = var.bastion_host.location
  resource_group_name = var.bastion_host.resource_group_name
  sku                 = "Developer"
  virtual_network_id  = var.bastion_host.vnet.id
}
