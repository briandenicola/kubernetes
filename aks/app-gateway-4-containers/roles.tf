resource "azurerm_role_assignment" "alb_identity_network_contributor" {
  scope                            = module.cluster.VNET_ID
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.alb_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "alb_identity_appgw_config_manager" {
  scope                            = data.azurerm_resource_group.this.id
  role_definition_name             = "AppGw for Containers Configuration Manager"
  principal_id                     = azurerm_user_assigned_identity.alb_identity.principal_id
  skip_service_principal_aad_check = true
}