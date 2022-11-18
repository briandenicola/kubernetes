resource "azapi_resource" "azureml_install" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type      = "Microsoft.KubernetesConfiguration/extensions@2022-07-01"
  name      = "azureml"
  parent_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
        extensionType                 = "Microsoft.AzureML.Kubernetes"
        autoUpgradeMinorVersion       = true
        scope                         = {
            cluster = {
                releaseNamespace      = "azureml"
            }
        }
        configurationSettings         = {
            enableInference               = "True"
            enableTraining                = "True"
            allowInsecureConnections      = "True"
            inferenceRouterServiceType    = "LoadBalancer"
            inferenceLoadBalancerHA       = "False"
        }
    }
  })
}