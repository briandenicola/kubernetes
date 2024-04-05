resource "azurerm_machine_learning_inference_cluster" "this" {
  name                  = "k8s-compute"
  location              = local.location
  cluster_purpose       = "DevTest"
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.this.id
  machine_learning_workspace_id = azurerm_machine_learning_workspace.this.id

  identity {
    type = "SystemAssigned"
  }

}