resource "azurerm_resource_group" "this" {
  name     = var.vm.resource_group_name
  location = var.vm.location
  tags = {
    Application = var.vm.tags
    Components  = "Jumpbox Virtual Machine; Bastion"
    DeployedOn  = timestamp()
  }
}
