data "azurerm_client_config" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

resource "random_password" "password" {
  length  = 25
  special = true
}

resource "random_integer" "vnet_cidr" {
  min = 10
  max = 250
}

resource "random_integer" "controlplane_services_cidr" {
  min = 64
  max = 127
}

resource "random_integer" "workload_services_cidr" {
  min = 64
  max = 127
}

locals {
  location                  = var.region
  resource_name             = "${random_pet.this.id}-${random_id.this.dec}"
  controlplane_name         = "${local.resource_name}-controlplane"
  aks_name                  = "${local.resource_name}-workload"
  flux_repository           = "https://github.com/briandenicola/kubernetes"
  mgmt_cluster_cfg_path     = "./cncf/crossplane-with-kubevela/infrastructure/cluster-config/management"
  crossplane_cfg_path       = "./cncf/crossplane-with-kubevela/infrastructure/cluster-config/management/upbound-providers"
  crossplane_creds_path     = "./cncf/crossplane-with-kubevela/infrastructure/cluster-config/management/upbound-providers-config"
  vnet_cidr                 = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  controlplane_subnet_cidr  = cidrsubnet(local.vnet_cidr, 8, 2)
  workload_subnet_cidr      = cidrsubnet(local.vnet_cidr, 8, 3)
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = "tbd"
    Components  = "aks; kubevela; crossplane; oam"
    DeployedOn  = timestamp()
    Deployer    = data.azurerm_client_config.current.object_id
  }
}

data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}
