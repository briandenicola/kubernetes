data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azuread_service_principal" "aro_resource_provider" {
  display_name = "Azure Red Hat OpenShift RP"
}