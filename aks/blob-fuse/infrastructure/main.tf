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
  tags                   = "Blob Fuse with Workload Identity"
  k8s_version            = "1.30"
  environment_type       = "dev"
}