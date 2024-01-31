data azurerm_kubernetes_cluster this {
  name                = var.aks_name
  resource_group_name = var.aks_rg_name
}

data "azurerm_application_insights" "this" {
  name                = var.ai_name
  resource_group_name = var.ai_rg_name
}