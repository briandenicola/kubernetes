resource "helm_release" "argocd" {
  depends_on = [
    azurerm_kubernetes_cluster.this,
  ]

  name             = "argo-cd-repo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "argo-cd.dex.enabled"
    value = false
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  name             = "jetstack"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true


  set {
    name  = "installCRDs"
    value = true
  }
}
