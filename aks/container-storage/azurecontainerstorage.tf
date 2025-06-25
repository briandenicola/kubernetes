resource "azurerm_kubernetes_cluster_extension" "storage" {
  depends_on = [
    module.cluster,
    azurerm_kubernetes_cluster_node_pool.acstor
  ]

  name              = "azurecontainerstorage"
  cluster_id        = module.cluster.AKS_CLUSTER_ID
  extension_type    = "microsoft.azurecontainerstorage"
  release_train     = "stable"
  release_namespace = "acstor"
}

