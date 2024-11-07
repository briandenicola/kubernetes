resource "azurerm_role_assignment" "aks_role_assignemnt_network" {
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

resource "azurerm_role_assignment" "aks_role_assignemnt_dns" {
  scope                            = azurerm_private_dns_zone.aks_private_zone.id
  role_definition_name             = "Private DNS Zone Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "keyvault_role_assignemnt_cluster_identity" {
  scope                            = azurerm_key_vault.this.id
  role_definition_name             = "Key Vault Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "jumpbox_managed_identity_aks_admin" {
  scope                            = azurerm_kubernetes_cluster.this.id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = azurerm_linux_virtual_machine.this.identity.0.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "jumpbox_managed_identity_contributor_rgs_monitor" {
  for_each                         = local.resource_groups
  scope                            = azurerm_resource_group.this[each.key].id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_linux_virtual_machine.this.identity.0.principal_id
  skip_service_principal_aad_check = true
}
