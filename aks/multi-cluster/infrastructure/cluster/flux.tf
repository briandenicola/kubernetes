resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.this.id
  extension_type = "microsoft.flux"
}