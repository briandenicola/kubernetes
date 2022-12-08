resource "azapi_resource" "flux_config" {
  depends_on = [
    azapi_resource.flux_install
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
        common = {
          path                   = local.common_path
          dependsOn              = []
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
        istio-crd = {
          path                   = local.istio_crd_path
          dependsOn              = [
            "common"
          ]
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
        istio-cfg = {
          path                   = local.istio_cfg_path
          dependsOn              = [
            "istio-crd"
          ]
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
        istio-gw = {
          path                   = local.istio_gw_path
          dependsOn              = [
            "istio-cfg"
          ]
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
        flagger = {
          path                   = local.flagger_path
          dependsOn              = [
            "istio-cfg"
          ]
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
        app = {
          path                   = local.app_path
          dependsOn              = [
            "flagger"
          ]
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
      }
    }
  })
}