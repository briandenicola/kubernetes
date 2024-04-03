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
  depends_on = [
    module.cluster
  ]
  name                = module.cluster.AKS_CLUSTER_NAME
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

data "azapi_resource_id" "cluster_identity" {
  type        = "Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30"
  resource_id = data.azurerm_kubernetes_cluster.this.identity.0.identity_ids.0
}

data "azurerm_user_assigned_identity" "cluster_identity" {
  name                = data.azapi_resource_id.cluster_identity.name
  resource_group_name = data.azapi_resource_id.cluster_identity.resource_group_name
}