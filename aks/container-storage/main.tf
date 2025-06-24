resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location             = var.region
  resource_name        = "${random_pet.this.id}-${random_id.this.dec}"
  vm_name              = "${local.resource_name}-jumpbox"
  vnet_name            = "${local.resource_name}-network"
  jumpbox_subnet_name  = "compute"
  authorized_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  app_path             = "./aks/container-storage/cluster-config"
  flux_repository      = "https://github.com/briandenicola/kubernetes"
  sdlc_environment     = "Dev"
}
