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
  aks_name             = "${local.resource_name}-aks"
  grafana_name         = "${local.resource_name}-grafana"
  prometheus_name      = "${local.resource_name}-prometheus"
  app_identity_name    = "${local.resource_name}-app-identity"
  namespace            = "prometheus-demo"
  tags                 = var.tags
  authorized_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  environment_type     = "dev"
  k8s_version          = "1.32"
}

# resource "azurerm_resource_group" "this" {
#   name     = "${local.resource_name}_rg"
#   location = local.location

#   tags = {
#     Application = local.tags
#     Components  = "AKS; Managed Prometheus; Azure Monitor; Azure Grafana; Windows Containers"
#     DeployedOn  = timestamp()
#   }
# }
