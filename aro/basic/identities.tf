resource "time_rotating" "ninety_days" {
  rotation_days = 90
}

resource "azuread_application" "this" {
  display_name = "${local.aro_name}-identity"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "this" {
  client_id                    = azuread_application.this.client_id
  app_role_assignment_required = false
  owners                       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_application_password" "this" {
  application_id = azuread_application.this.id
}
