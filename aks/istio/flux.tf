# resource "azapi_resource" "flux_install" {
#   depends_on = [
#     azurerm_kubernetes_cluster.this
#   ]

#   type      = "Microsoft.KubernetesConfiguration/extensions@2021-09-01"
#   name      = "flux"
#   parent_id = azurerm_kubernetes_cluster.this.id

#   body = jsonencode({
#     properties = {
#       extensionType           = "microsoft.flux"
#       autoUpgradeMinorVersion = true
#     }
#   })
# }

resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on = [
    azapi_update_resource.istio_ingressgateway
  ]
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.this.id
  extension_type = "microsoft.flux"
}

resource "azapi_resource" "flux_config" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]

  type      = "Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01"
  name      = "cluster-config"
  parent_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties : {
      scope      = "cluster"
      namespace  = "flux-system"
      sourceKind = "GitRepository"
      suspend    = false
      gitRepository = {
        url                   = local.flux_repository
        timeoutInSeconds      = 600
        syncIntervalInSeconds = 300
        repositoryRef = {
          branch = "main"
        }
      }
      kustomizations : {
        apps = {
          path                   = local.cluster_path
          dependsOn              = []
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
      }
    }
  })
}