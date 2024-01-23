resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location              = var.region
  resource_name         = "${random_pet.this.id}-${random_id.this.dec}"
  tags                  = "aks; prometheus"
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = "otel"
    Components  = local.tags
    DeployedOn  = timestamp()
  }
}
