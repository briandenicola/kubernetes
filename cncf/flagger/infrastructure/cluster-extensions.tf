resource "azapi_resource" "flux_install" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type      = "Microsoft.KubernetesConfiguration/extensions@2021-09-01"
  name      = "flux"
  parent_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      extensionType           = "microsoft.flux"
      autoUpgradeMinorVersion = true
    }
  })
}