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
  max = 99
}

resource "random_integer" "pod_cidr" {
  min = 100
  max = 127
}

locals {
  location             = var.region
  resource_name        = "${random_pet.this.id}-${random_id.this.dec}"
  aca_name             = "${local.resource_name}-env"
  #container_image      = "bjd145/httpbin:1087"
  container_image      = "bjd145/httpbin:1088"
  acr_name             = "${replace(local.resource_name, "-", "")}acr"
  vnet_cidr            = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir      = cidrsubnet(local.vnet_cidr, 8, 1)
  nodes_subnet_cidir   = cidrsubnet(local.vnet_cidr, 8, 2)
  compute_subnet_cidir = cidrsubnet(local.vnet_cidr, 8, 3)
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
