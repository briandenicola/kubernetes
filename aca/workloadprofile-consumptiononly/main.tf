data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

locals {
  location              = var.region
  resource_name         = "${random_pet.this.id}-${random_id.this.dec}"
  non_az_regions        = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  aca_name              = "${local.resource_name}-env"
  app_name              = "httpbin"
  workload_profile_name = "Consumption"
  nat_name              = "${local.resource_name}-nat"
  vm_name               = "${local.resource_name}-vm"
  bastion_name          = "${local.resource_name}-bastion"
  apps_image            = "bjd145/httpbin:1087"
  utils_image           = "bjd145/utils:3.15"
  sdlc_environment      = "Development"
  vnet_cidr             = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  bastion_subnet_cidir  = cidrsubnet(local.vnet_cidr, 8, 1)
  pe_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 2)
  compute_subnet_cidir  = cidrsubnet(local.vnet_cidr, 8, 3)
  nodes_subnet_cidir    = cidrsubnet(local.vnet_cidr, 8, 4)

  jump_vm_sku  = "Standard_B1ms"
  jump_vm_zone = contains(local.non_az_regions, local.location) ? null : random_integer.vm_zone.result
}

