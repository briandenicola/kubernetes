resource "azurerm_role_assignment" "aro_cluster_service_principal_user_access_administrator" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.this.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aro_cluster_service_principal_contributor" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.this.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aro_cluster_service_principal_network_contributor" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.this.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aro_resource_provider_service_principal_network_contributor" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Network Contributor"
  principal_id         = var.aro_rp_aad_sp_object_id
  skip_service_principal_aad_check = true
}
