resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  resource_name          = "${random_pet.this.id}-${random_id.this.dec}"
  authorized_ip_ranges   = ["${chomp(data.http.myip.response_body)}/32"]
  workload_identity      = "${local.resource_name}-app-identity"
  storage_name           = "${replace(local.resource_name, "-", "")}sa"
  storage_container_name = "test"
  tags                   = var.tags
}

module "cluster" {
  source               = "../../modules/aks.v3"
  region               = var.region
  zones                = ["1"]
  authorized_ip_ranges = local.authorized_ip_ranges
  resource_name        = local.resource_name
  public_key_openssh   = tls_private_key.rsa.public_key_openssh
  tags                 = local.tags
  kubernetes_version   = "1.30"
  sdlc_environment     = "dev"
  enable_csi_drivers   = false
  enable_mesh          = false
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = var.region

  tags = {
    Application = local.tags
    Components  = "AKS; Storage; Workload Identity"
    DeployedOn  = timestamp()
  }
}
