resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location                    = var.region
  resource_name               = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name                    = "${local.resource_name}-aks"
  aks_node_rg_name            = "${local.aks_name}_nodes_rg"
  vnet_name                   = "${local.resource_name}-network"
  nsg_name                    = "${local.resource_name}-default-nsg"
  azuremonitor_workspace_name = "${local.resource_name}-prometheus"
  vnet_cidr                   = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir             = cidrsubnet(local.vnet_cidr, 8, 1)
  api_subnet_cidir            = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir          = cidrsubnet(local.vnet_cidr, 8, 3)
  compute_subnet_cidir        = cidrsubnet(local.vnet_cidr, 8, 10)
  authorized_ip_ranges        = ["${chomp(data.http.myip.response_body)}/32"]
}
