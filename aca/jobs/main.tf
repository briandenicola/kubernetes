data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

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

resource "random_integer" "vnet_cidr" {
  min = 10
  max = 250
}

locals {
  location              = var.region
  resource_name         = "${random_pet.this.id}-${random_id.this.dec}"
  aca_name              = "${local.resource_name}-env"
  app_name              = "${local.resource_name}-job"
  workload_profile_name = "Consumption"
  fw_name               = "${local.resource_name}-fw"
  apps_image            = "mcr.microsoft.com/k8se/quickstart-jobs:latest"
  utils_image           = "bjd145/utils:3.15"
  vnet_cidr             = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 1)
  compute_subnet_cidir  = cidrsubnet(local.vnet_cidr, 8, 2)
  fw_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 3)
  nodes_subnet_cidir    = cidrsubnet(local.vnet_cidr, 8, 4)
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
