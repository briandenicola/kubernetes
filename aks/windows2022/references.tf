data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_resource_group" "this" {
  depends_on = [module.aks_cluster]
  name       = module.aks_cluster.AKS_RESOURCE_GROUP
}

data "azurerm_kubernetes_cluster" "this" {
  depends_on          = [module.aks_cluster]
  name                = module.aks_cluster.AKS_CLUSTER_NAME
  resource_group_name = module.aks_cluster.AKS_RESOURCE_GROUP
}