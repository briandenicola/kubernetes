resource "azurerm_kubernetes_cluster_extension" "storage" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  name              = "azurecontainerstorage"
  cluster_id        = azurerm_kubernetes_cluster.this.id
  extension_type    = "microsoft.azurecontainerstorage"
  release_train     = "prod"
  release_namespace = "acstor-system"
}
