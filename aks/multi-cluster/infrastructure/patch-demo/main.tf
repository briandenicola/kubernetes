resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  resource_name        = "${random_pet.this.id}-${random_id.this.dec}"
  authorized_ip_ranges = [ "${chomp(data.http.myip.response_body)}/32" ]
  fleet_name           = "${local.resource_name}-fleet"
}

module "cluster_resources" {
  for_each                  = toset(var.sdlc_environments)
  source                    = "../cluster"
  region                    = var.region
  authorized_ip_ranges      = local.authorized_ip_ranges
  resource_name             = "${local.resource_name}-${each.value}"
  public_key_openssh        = tls_private_key.rsa.public_key_openssh
  sdlc_environment          = each.value
  kubernetes_version        = "1.26.10"
  automatic_channel_upgrade = var.automatic_channel_upgrade
  node_os_channel_upgrade   = var.node_os_channel_upgrade
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = var.region

  tags = {
    Application = "AKS Fleet Patch Demo"
    Components  = "Fleet Manager"
    DeployedOn  = timestamp()
  }
}
