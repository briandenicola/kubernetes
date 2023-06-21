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

resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  name              = "flux"
  cluster_id        = azurerm_kubernetes_cluster.this.id
  extension_type    = "microsoft.flux"
  release_train     = "prod"
  release_namespace = "flux-system"
}

resource "azapi_resource" "flux_config" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]

  type      = "Microsoft.KubernetesConfiguration/fluxConfigurations@2022-11-01"
  name      = "aks-flux-extension"
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
          path = local.app_path
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
      }
    }
  })
}
