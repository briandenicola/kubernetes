resource "azurerm_kubernetes_cluster_extension" "dapr" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux,
  ]
  name              = "dapr"
  cluster_id        = module.cluster.AKS_CLUSTER_ID
  extension_type    = "microsoft.dapr"
  release_namespace = "dapr-system"
}
