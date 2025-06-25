
locals {
  location             = var.region
  tags                 = var.tags
  non_az_regions       = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  aks_name             = "${var.resource_name}-aks"
  acr_account_name     = "${replace(var.resource_name, "-", "")}acr"
  virtual_network_name = "${var.resource_name}-vnet"
  nsg_name             = "${var.resource_name}-default-nsg"
  aks_node_rg_name     = "${local.aks_name}_nodes_rg"
  nat_name             = "${var.resource_name}-nat"
  vnet_cidr            = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir      = cidrsubnet(local.vnet_cidr, 8, 1)
  api_subnet_cidir     = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir   = cidrsubnet(local.vnet_cidr, 8, 3)
  alb_subnet_cidir     = cidrsubnet(local.vnet_cidr, 8, 4)
  compute_subnet_cidir = cidrsubnet(local.vnet_cidr, 8, 10)
}

resource "azurerm_resource_group" "this" {
  name     = "${local.aks_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "AKS; Virtual Network; NSG"
    Environment = var.sdlc_environment
    DeployedOn  = timestamp()
  }
}
