
resource "azurerm_role_assignment" "container_storage_role" {
  depends_on = [
    data.azurerm_resource_group.aks_nodepool_rg
  ]
  scope                            = data.azurerm_resource_group.aks_nodepool_rg.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}