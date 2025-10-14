# resource "time_rotating" "ninety_days" {
#   rotation_days = 90
# }

# resource "azuread_application" "this" {
#   display_name = "${local.aro_name}-identity"
#   owners       = [data.azurerm_client_config.current.object_id]
# }

# resource "azuread_service_principal" "this" {
#   client_id                    = azuread_application.this.client_id
#   app_role_assignment_required = false
#   owners                       = [data.azurerm_client_config.current.object_id]
# }

# resource "azuread_service_principal_password" "this" {
#   service_principal_id = azuread_service_principal.this.id
#   end_date = formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timeadd(timestamp(), "240h")) #10 days from now in RFC3339 format
# }

data "azuread_service_principal" "this" {
  client_id                    = var.aro_client_id
}