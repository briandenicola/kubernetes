data "azurerm_log_analytics_workspace" "this" {
  name                = local.la_name
  resource_group_name = local.global_rg_name
}

data "azurerm_application_insights" "this" {
  name                = local.ai_name
  resource_group_name = local.global_rg_name
}
