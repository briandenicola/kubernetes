data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "random_integer" "vnet_cidr" {
  min = 10
  max = 250
}

resource "random_integer" "services_cidr" {
  min = 64
  max = 99
}

resource "random_integer" "pod_cidr" {
  min = 100
  max = 127
}

locals {
  location             = var.region
  aks_name             = "${var.resource_name}-aks"
  aks_node_rg_name     = "${local.aks_name}_nodes_rg"
  vnet_cidr            = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir      = cidrsubnet(local.vnet_cidr, 8, 1)
  api_subnet_cidir     = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir   = cidrsubnet(local.vnet_cidr, 8, 3)
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
