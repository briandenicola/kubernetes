resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  resource_name        = "${random_pet.this.id}-${random_id.this.dec}"
  authorized_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  fleet_name           = "${local.resource_name}-fleet"
  kubernetes_version   = "1.31"
}
