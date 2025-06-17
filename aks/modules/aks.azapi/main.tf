
locals {
  location             = var.region
  aks_name             = "${var.resource_name}-aks"
  aks_node_rg_name     = "${local.aks_name}_nodes_rg"
  nat_name             = "${var.resource_name}-nat"
  vnet_cidr            = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir      = cidrsubnet(local.vnet_cidr, 8, 1)
  api_subnet_cidir     = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir   = cidrsubnet(local.vnet_cidr, 8, 3)
  compute_subnet_cidir = cidrsubnet(local.vnet_cidr, 8, 10)
}

