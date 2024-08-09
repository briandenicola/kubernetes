resource "azurerm_kubernetes_cluster_extension" "azureml" {
  depends_on = [
    data.azurerm_kubernetes_cluster.this,
    azurerm_private_dns_zone_virtual_network_link.azureml,
    azurerm_machine_learning_workspace.this,
    azurerm_network_security_group.ml
  ]
  name              = "azureml"
  cluster_id        = data.azurerm_kubernetes_cluster.this.id
  extension_type    = "microsoft.azureml.kubernetes"
  release_namespace = "azureml"
  release_train     = "stable"

  configuration_settings = {
    "InferenceRouterHA"                                     = "False"
    "allowInsecureConnections"                              = "True"    
    "clusterId"                                             = data.azurerm_kubernetes_cluster.this.id
    "clusterPurpose"                                        = "DevTest"
    "cluster_name"                                          = data.azurerm_kubernetes_cluster.this.id
    "cluster_name_friendly"                                 = data.azurerm_kubernetes_cluster.this.name
    "domain"                                                = "${local.location}.cloudapp.azure.com"
    "enableTraining"                                        = "True"
    "enableInference"                                       = "True"
    "inferenceRouterHA"                                     = "false"
    "inferenceRouterServiceType"                            = "LoadBalancer"
    "jobSchedulerLocation"                                  = local.location
    "location"                                              = local.location
    "nginxIngress.enabled"                                  = "true"
    "prometheus.prometheusSpec.externalLabels.cluster_name" = data.azurerm_kubernetes_cluster.this.id
    "relayserver.enabled"                                   = "false"
    "servicebus.enabled"                                    = "false"
  }
}