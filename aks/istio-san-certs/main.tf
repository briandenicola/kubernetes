resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location                  = var.region
  resource_name             = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name                  = module.cluster.AKS_CLUSTER_NAME
  keyvault_name             = "${local.resource_name}-vault"
  authorized_ip_ranges      = ["${chomp(data.http.myip.response_body)}/32"]
  aks_service_mesh_identity = "${local.aks_name}-${var.service_mesh_type}-pod-identity"
}
