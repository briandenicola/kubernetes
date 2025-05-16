
locals {
  location              = var.region
  non_az_regions        = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  resource_name         = "${random_pet.this.id}-${random_id.this.dec}"
  sdlc_environment      = "Dev"

  rg_name               = "${local.resource_name}_app_rg"
  vnet_name             = "${local.resource_name}-vnet"
  aks_name              = "${local.resource_name}-aks"
  bastion_name          = "${local.resource_name}-bastion"
  nat_name              = "${local.resource_name}-nat"
  vm_name               = "${local.resource_name}-vm"
  acr_account_name      = "${replace(local.resource_name, "-", "")}acr"

  kubernetes_version    = "1.31" #data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 1]
  istio_version         = "asm-1-24"

  vnet_cidr             = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 1)
  api_subnet_cidir      = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir    = cidrsubnet(local.vnet_cidr, 8, 3)
  compute_subnet_cidir  = cidrsubnet(local.vnet_cidr, 8, 4)

  jump_vm_sku           = "Standard_B1ms"
  jump_vm_zone          = contains(local.non_az_regions, local.location) ? null : random_integer.vm_zone.result
}
