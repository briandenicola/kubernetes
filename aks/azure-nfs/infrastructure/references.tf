data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_kubernetes_cluster" "this" {
  depends_on          = [module.cluster]
  name                = module.cluster.AKS_CLUSTER_NAME
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

locals {
  cluster_identity_id = split("/", data.azurerm_kubernetes_cluster.this.identity.0.identity_ids.0)
  cluster_identity    = element(local.cluster_identity_id, length(local.cluster_identity_id) - 1)
  virtual_network_id  = split("/", data.azurerm_kubernetes_cluster.this.agent_pool_profile.0.vnet_subnet_id)
  vnet_name           = element(local.virtual_network_id, length(local.virtual_network_id) - 3)
}

data "azurerm_resource_group" "aks" {
  name = module.cluster.AKS_RESOURCE_GROUP  
}

data "azurerm_user_assigned_identity" "cluster_identity" {
  name                = local.cluster_identity
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

data "azurerm_virtual_network" "cluster_vnet" {
  name                = local.vnet_name
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

data "azurerm_subnet" "pe" {
  virtual_network_name = local.vnet_name
  resource_group_name  = module.cluster.AKS_RESOURCE_GROUP
  name                 = "private-endpoints"
}
