resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.storage
  ]

  name              = "flux"
  cluster_id        = data.azurerm_kubernetes_cluster.this.id
  extension_type    = "microsoft.flux"
  release_namespace = "flux-system"
}

resource "azurerm_kubernetes_flux_configuration" "flux_config" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]

  name       = "aks-flux-extension"
  cluster_id = data.azurerm_kubernetes_cluster.this.id
  namespace  = "flux-system"
  scope      = "cluster"

  git_repository {
    url                      = local.flux_repository
    reference_type           = "branch"
    reference_value          = "main"
    timeout_in_seconds       = 600
    sync_interval_in_seconds = 30
  }

  kustomizations {
    name                       = "apps"
    path                       = local.app_path
    timeout_in_seconds         = 600
    sync_interval_in_seconds   = 120
    retry_interval_in_seconds  = 300
    garbage_collection_enabled = true
    depends_on                 = []
  }
}