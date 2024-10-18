module "azure_monitor" {
  source                   = "../../modules/observability"
  region                   = var.region
  resource_name            = local.resource_name
  tags                     = local.tags
  sdlc_environment         = local.environment_type
  enable_managed_offerings = var.enable_managed_offerings
}

resource "azurerm_monitor_data_collection_rule_association" "this" {
  depends_on = [
    module.azure_monitor,
    module.aks_cluster
  ]
  count                   = var.enable_managed_offerings ? 1 : 0
  name                    = "${local.resource_name}-ama-datacollection-rules-association"
  target_resource_id      = module.aks_cluster.AKS_CLUSTER_ID
  data_collection_rule_id = module.azure_monitor.DATA_COLLECTION_RULES_ID
}

resource "azurerm_monitor_data_collection_rule_association" "container_insights" {
  count                   = var.enable_managed_offerings ? 1 : 0
  name                    = "${local.resource_name}-ama-container-insights-rules-association"
  target_resource_id      = module.aks_cluster.AKS_CLUSTER_ID
  data_collection_rule_id = module.azure_monitor.DATA_COLLECTION_RULE_CONTAINER_INSIGHTS_ID
}
