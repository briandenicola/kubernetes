data "azurerm_kubernetes_cluster" "this" {
  depends_on = [
    module.cluster
  ]
  name                = module.cluster.AKS_CLUSTER_NAME
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

resource "azurerm_kubernetes_cluster_extension" "storage" {
  depends_on = [
    data.azurerm_kubernetes_cluster.this
  ]

  name              = "azurecontainerstorage"
  cluster_id        = data.azurerm_kubernetes_cluster.this.id
  extension_type    = "microsoft.azurecontainerstorage"
  release_train     = "stable"
  release_namespace = "acstor"
}

