resource "azapi_resource" "workload_cluster_flux_install" {
  depends_on = [
    azurerm_kubernetes_cluster.controlplane
  ]

  type      = "Microsoft.KubernetesConfiguration/extensions@2022-03-01"
  name      = "flux"
  parent_id = azurerm_kubernetes_cluster.workload.id

  body = jsonencode({
    properties = {
      extensionType           = "microsoft.flux"
      autoUpgradeMinorVersion = true
    }
  })
}

resource "azapi_resource" "workload_cluster_flux_config" {
  depends_on = [
    azapi_resource.workload_cluster_flux_install
  ]

  type      = "Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01"
  name      = "cluster-config"
  parent_id = azurerm_kubernetes_cluster.workload.id

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
        addons = {
          path                   = local.workload_cluster_cfg_path
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