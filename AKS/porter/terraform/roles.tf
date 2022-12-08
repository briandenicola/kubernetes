resource "azurerm_role_assignment" "aks_role_assignemnt_nework" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_role_assignemnt_msi" {
  scope                = azurerm_user_assigned_identity.aks_kubelet_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true 
}

resource "azurerm_role_assignment" "cluster_owner" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kubelet_acr_push" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPush"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kubelet_acr_pull" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
  skip_service_principal_aad_check = true
}
