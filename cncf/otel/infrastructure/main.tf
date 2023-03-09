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

resource "random_integer" "services_cidr" {
  min = 64
  max = 127
}

locals {
  location        = var.region
  resource_name   = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name        = "${local.resource_name}-aks"
  vnet_cidr       = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  subnet_cidir    = cidrsubnet(local.vnet_cidr, 8, 2)
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = "otel-demo"
    Components  = "aks; otel"
    DeployedOn  = timestamp()
  }
}
