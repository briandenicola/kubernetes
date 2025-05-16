

locals {
  location                    = var.region
  tags                        = var.tags  
  resource_name               = "${random_pet.this.id}-${random_id.this.dec}"
  app_identity_name           = "${local.resource_name}-identity"
  kubernetes_version          = "1.31"
  authorized_ip_ranges        = ["${jsondecode(data.http.myip.response_body).ip}/32"]
  sdlc_environment            = "Production"
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
