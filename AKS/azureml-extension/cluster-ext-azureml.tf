resource "azapi_resource" "azureml_install" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type      = "Microsoft.KubernetesConfiguration/extensions@2022-07-01"
  name      = "azureml"
  parent_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      extensionType           = "Microsoft.AzureML.Kubernetes"
      autoUpgradeMinorVersion = true
      scope = {
        cluster = {
          releaseNamespace = "azureml"
        }
      }
      configurationSettings = {
        enableInference                                         = "True"
        enableTraining                                          = "True"
        allowInsecureConnections                                = "True"
        inferenceRouterServiceType                              = "LoadBalancer"
        inferenceLoadBalancerHA                                 = "False"
        "relayserver.enabled"                                   = "False"
        "nginxIngress.enabled"                                  = "True"
        "servicebus.enabled"                                    = "False"
        "scoringFe.serviceType.nodePort"                        = "False"
        installVolcano                                          = "True"
        installPromOp                                           = "True"
        clusterId                                               = azurerm_kubernetes_cluster.this.id
        cluster_name                                            = azurerm_kubernetes_cluster.this.id
        cluster_name_friendly                                   = local.aks_name
        domain                                                  = "${azurerm_resource_group.this.location}.cloudapp.azure.com"
        jobSchedulerLocation                                    = azurerm_resource_group.this.location
        location                                                = azurerm_resource_group.this.location
        "prometheus.prometheusSpec.externalLabels.cluster_name" = azurerm_kubernetes_cluster.this.id
      }
    }
  })
}
