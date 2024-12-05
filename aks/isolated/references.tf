data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azurerm_kubernetes_service_versions" "current" {
  location = local.location
}