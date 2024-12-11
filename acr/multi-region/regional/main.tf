terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
  }
}

resource "random_integer" "vnet_cidr" {
  min = 10
  max = 250
}

locals {
  non_az_regions                 = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  apps_rg_name                   = "${var.app_name}_${var.location}_rg"
  global_rg_name                 = "${var.app_name}_core_rg"
  acr_name                       = "${replace(var.app_name, "-", "")}acr"
  regional_name                  = "${var.app_name}-${var.location}"
  vnet_name                      = "${local.regional_name}-vnet"
  la_name                        = "${var.app_name}-logs"
  ai_name                        = "${var.app_name}-ai"
  bastion_name                   = "${local.regional_name}-bastion"
  vm_name                        = "${local.regional_name}-vm"
  vnet_cidr                      = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir                = cidrsubnet(local.vnet_cidr, 8, 1)
  compute_subnet_cidir           = cidrsubnet(local.vnet_cidr, 8, 2)
  fw_subnet_cidir                = cidrsubnet(local.vnet_cidr, 8, 3)
  sdlc_environment               = "Dev"
  jump_vm_sku                    = "Standard_B1ms"
  zone                           = contains(local.non_az_regions, var.location) ? null : [random_integer.zone.result]
  jump_vm_zone                   = contains(local.non_az_regions, var.location) ? null : random_integer.zone.result
}