resource "random_integer" "pod_cidr" {
  min = 100
  max = 127
}

resource "random_integer" "services_cidr" {
  min = 64
  max = 99
}

locals {
  aks_name           = var.aks_cluster.name
  non_az_regions     = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  aks_node_rg_name   = "${local.aks_name}_nodes_rg"
  location           = var.aks_cluster.location
  istio_version      = [var.aks_cluster.istio.version]
  kubernetes_version = var.aks_cluster.version
  aks_zones          = ["3"] #contains(local.non_az_regions, local.location) ? null : var.zones
}
