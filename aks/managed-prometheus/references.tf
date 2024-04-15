resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "http" "myip" {
  url = "https://api64.ipify.org?format=json"

  request_headers = {
    Accept = "application/json"
  }
}

data "azurerm_application_insights" "this" {
  depends_on = [
    module.aks_cluster
  ]
  name                = local.app_insights_name
  resource_group_name = module.aks_cluster.AKS_RESOURCE_GROUP
}
