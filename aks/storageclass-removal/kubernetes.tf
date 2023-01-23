resource "kubernetes_secret" "http-credentials" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  metadata {
    name      = "http-credentials"
    namespace = "flux-system"
  }

  data = {
    username = "admin"
    password = var.flux_secret_value
  }
}
