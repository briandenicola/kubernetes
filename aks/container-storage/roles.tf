resource "azurerm_role_assignment" "aks_role_assignemnt_nework" {
  scope                            = azurerm_virtual_network.this.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_role_assignemnt_msi" {
  scope                            = azurerm_user_assigned_identity.aks_kubelet_identity.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}

data "azurerm_resource_group" "aks_nodepool_rg" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  name = local.aks_node_rg_name
}

resource "azurerm_role_assignment" "container_storage_role" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  scope                            = data.azurerm_resource_group.aks_nodepool_rg.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
  skip_service_principal_aad_check = true
}
