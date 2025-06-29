data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azurerm_kubernetes_service_versions" "current" {
  location = local.location
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
