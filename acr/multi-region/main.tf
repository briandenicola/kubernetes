resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location             = var.regions[0]
  resource_name        = "${random_pet.this.id}-${random_id.this.dec}"
  acr_name             = "${replace(local.resource_name, "-", "")}acr"
  ai_name              = "${local.resource_name}-ai"
  la_name              = "${local.resource_name}-logs"
  authorized_ip_ranges = "${chomp(data.http.myip.response_body)}/32"
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_core_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = ""
    DeployedOn  = timestamp()
    Deployer    = data.azurerm_client_config.current.object_id
  }
}
