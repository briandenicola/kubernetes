resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location                    = var.region
  tags                        = var.tags  
  resource_name               = "${random_pet.this.id}-${random_id.this.dec}"
  app_identity_name           = "${local.resource_name}-identity"
  azuremonitor_workspace_name = "${local.resource_name}-prometheus"
  app_insights_name           = "${local.resource_name}-appinsights"
  kubernetes_version          = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 1]
  authorized_ip_ranges        = ["${jsondecode(data.http.myip.response_body).ip}/32"]
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = local.tags
    Components  = "AKS; Managed Prometheus; Azure Monitor; Azure Grafana"
    DeployedOn  = timestamp()
  }
}
