resource "helm_release" "keda" {
  depends_on = [
    azurerm_kubernetes_cluster.this,
    azurerm_role_assignment.github_actions
  ]
  
  name              = "kedacore"
  repository        = "https://kedacore.github.io/charts"
  chart             = "keda"
  namespace         = "keda-system"
  create_namespace  = true

}

resource "helm_release" "dapr" {
  depends_on = [
    azurerm_kubernetes_cluster.this,
    azurerm_role_assignment.github_actions,
    helm_release.keda
  ]
  
  name              = "dapr"
  repository        = "https://dapr.github.io/helm-charts"
  chart             = "dapr"
  namespace         = "dapr-system"
  create_namespace  = true
  version           = "1.7.3"
  set {
    name  = "global.mtls.enabled"
    value = "true"
  }

  set {
    name  = "global.logAsJson"
    value = "true"
  }

  set {
    name  = "global.ha.enabled"
    value = "true"
  }
}