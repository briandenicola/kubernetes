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
  authorized_ip_ranges = [ "${chomp(data.http.myip.response_body)}/32" ]
  app_path             = "./aks/container-storage/cluster-config"
  flux_repository      = "https://github.com/briandenicola/kubernetes"
  tags                 = "Azure Container Storage Demo"
}
