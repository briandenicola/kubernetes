
locals {
  location              = var.region
  non_az_regions        = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  resource_name         = "${random_pet.this.id}-${random_id.this.dec}"
  sdlc_environment      = "Dev"

  rg_name               = "${local.resource_name}_app_rg"
  vnet_name             = "${local.resource_name}-vnet"
  bastion_name          = "${local.resource_name}-bastion"
  nat_name              = "${local.resource_name}-nat"
  vm_name               = "${local.resource_name}-vm"


  kubernetes_version    = "1.32" 

  vnet_cidr             = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 1)
  api_subnet_cidir      = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir    = cidrsubnet(local.vnet_cidr, 8, 3)
  compute_subnet_cidir  = cidrsubnet(local.vnet_cidr, 8, 4)

  jump_vm_sku           = "Standard_B2s_v2"
  jump_vm_zone          = contains(local.non_az_regions, local.location) ? null : random_integer.vm_zone.result
}
