module "vm" {
  count = var.deploy_jumpbox ? 1 : 0
  source = "../modules/jumpbox"

  resource_name = local.resource_name
  vm = {
    name                = "${local.resource_name}-jumpbox"
    location            = local.location
    resource_group_name = "${local.resource_name}-jumpbox_rg"
    tags                = var.tags
    zone                = local.jump_vm_zone
    sku                 = "Standard_B2s_v2"
    admin = {
      username     = "manager"
      ssh_key_path = "~/.ssh/id_rsa.pub"
    }
    vnet = {
      id        = data.azurerm_virtual_network.this.id
      subnet_id = data.azurerm_subnet.jumpbox.id
    }
  }

}
