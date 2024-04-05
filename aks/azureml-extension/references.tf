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
  depends_on = [
    module.cluster
  ]
  name = module.cluster.AKS_RESOURCE_GROUP
}

data "azurerm_application_insights" "this" {
  name                = local.application_insights_name
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

data "azurerm_kubernetes_cluster" "this" {
  depends_on = [
    module.cluster
  ]
  name                = module.cluster.AKS_CLUSTER_NAME
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

data "azurerm_virtual_network" "this" {
  depends_on = [
    module.cluster
  ]
  name                = local.virtual_network_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "pe" {
  depends_on = [
    module.cluster
  ]
  name                 = "private-endpoints"
  virtual_network_name = local.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "compute" {
  depends_on = [
    module.cluster
  ]
  name                 = "compute"
  virtual_network_name = local.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.this.name
}
