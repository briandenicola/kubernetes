module "azure_monitor" {
  source               = "../modules/observability"
  region               = var.region
  resource_name        = local.resource_name
  tags                 = var.tags
  sdlc_environment     = local.environment_type
}

resource "azurerm_monitor_data_collection_rule_association" "this" {
  depends_on = [ 
    module.azure_monitor,
    module.aks_cluster
  ]
  name                    = "${local.resource_name}-ama-datacollection-rules-association"
  target_resource_id      = module.aks_cluster.AKS_CLUSTER_ID
  data_collection_rule_id = module.azure_monitor.DATA_COLLECTION_RULES_ID
}
