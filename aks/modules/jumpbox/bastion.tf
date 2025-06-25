resource "azurerm_bastion_host" "this" {
  name                = local.bastion_name
  location            = var.vm.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Developer"
  virtual_network_id  = var.vm.vnet.id
}
