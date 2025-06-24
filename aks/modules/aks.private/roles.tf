resource "azurerm_role_assignment" "aks_role_assignemnt_network" {
  scope                            = var.azurerm_virtual_network_id
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
