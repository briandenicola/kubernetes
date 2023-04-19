data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "http" "myip" {
  url = "https://api64.ipify.org?format=json"

  request_headers = {
    Accept = "application/json"
  }
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

resource "random_integer" "services_cidr" {
  min = 64
  max = 127
}

locals {
  location              = var.region
  ip_address            = "${jsondecode(data.http.myip.response_body).ip}"
  resource_name         = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name              = "${local.resource_name}-aks"
  acr_name              = "${replace(local.resource_name,"-","")}acr"
  vnet_cidr             = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 1)
  api_subnet_cidir      = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir    = cidrsubnet(local.vnet_cidr, 8, 3)
  compute_subnet_cidir  = cidrsubnet(local.vnet_cidr, 8, 10)
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = "tbd"
    Components  = "aks;"
    DeployedOn  = timestamp()
  }
}
