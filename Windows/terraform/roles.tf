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

resource "azurerm_role_assignment" "github_actions" {
    scope                = azurerm_kubernetes_cluster.this.id
    role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
    principal_id         = data.azurerm_client_config.current.object_id
    skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "github_actions_aks_read" {
    scope                = azurerm_kubernetes_cluster.this.id
    role_definition_name = "Azure Kubernetes Service Cluster User Role"
    principal_id         = data.azurerm_client_config.current.object_id
    skip_service_principal_aad_check = true
}