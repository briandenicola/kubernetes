resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on = [
    azapi_resource.aks
  ]
  
  count          = var.aks_cluster.flux.enabled ? 1 : 0
  name           = "flux"
  cluster_id     = azapi_resource.aks.id
  extension_type = "microsoft.flux"
}