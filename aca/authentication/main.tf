locals {
  location              = var.region
  non_az_regions        = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  resource_name         = "${random_pet.this.id}-${random_id.this.dec}"
  aca_name              = "${local.resource_name}-environment"
  bastion_name          = "${local.resource_name}-bastion"
  vm_name               = "${local.resource_name}-vm"
  vnet_cidr             = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  workload_profile_name = "Consumption"
  pe_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 1)
  nodes_subnet_cidir    = cidrsubnet(local.vnet_cidr, 8, 3)
  compute_subnet_cidir  = cidrsubnet(local.vnet_cidr, 8, 10)
  aca_zones             = contains(local.non_az_regions, local.location) ? false : var.zones

  jump_vm_sku           = "Standard_B1ms"
  jump_vm_zone          = contains(local.non_az_regions, local.location) ? null : random_integer.vm_zone.result
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Azure Container Apps"
    DeployedOn  = timestamp()
  }
}
