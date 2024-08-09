resource "azurerm_role_assignment" "aks_cluster_access" {
  scope                            = data.azurerm_kubernetes_cluster.this.id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = azurerm_machine_learning_workspace.this.identity[0].principal_id
  skip_service_principal_aad_check = true
}