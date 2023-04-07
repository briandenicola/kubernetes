resource "azurerm_log_analytics_workspace" "this" {
  name                          = "${local.resource_name}-logs"
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  sku                           = "PerGB2018"
  daily_quota_gb                = 0.5
  local_authentication_disabled = true
}

resource "azurerm_log_analytics_solution" "this" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_application_insights" "this" {
  name                          = "${local.resource_name}-appinsights"
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  workspace_id                  = azurerm_log_analytics_workspace.this.id
  application_type              = "web"
  local_authentication_disabled = false
}

locals {
  container_insights_tables = ["ContainerLogV2"]
}

//Table Update requires PATCH to change to Basic Plan but azapi_update_resource only does PUT updates 
resource "null_resource" "container_insights_basic_plan" {
  for_each = toset(local.container_insights_tables)
  depends_on = [
    azurerm_log_analytics_solution.this
  ]
  provisioner "local-exec" {
    command = "az monitor log-analytics workspace table update --resource-group ${azurerm_resource_group.this.name}  --workspace-name ${azurerm_log_analytics_workspace.this.name} --name ${each.key}  --plan Basic"
  }
}

resource "azurerm_monitor_data_collection_rule" "log_analytics" {
  name                = "${local.resource_name}-law-datacollection-rules"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  depends_on = [
    azurerm_log_analytics_workspace.this
  ]

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
      name                  = "ciworkspace"
    }
  }

  data_flow {
    streams      = ["Microsoft-ContainerInsights-Group-Default"]
    destinations = ["ciworkspace"]
  }

  data_sources {
    extension {
      streams        = ["Microsoft-ContainerInsights-Group-Default"]
      extension_name = "ContainerInsights"
      name           = "ContainerInsightsExtension"
    }
  }
}

resource "azapi_resource" "log_analytics_datacollection_rule_associations" {
  type      = "Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview"
  name      = "${local.resource_name}-law-datacollection-rules-association"
  parent_id = azurerm_kubernetes_cluster.this.id
  body = jsonencode({
    properties = {
      dataCollectionRuleId = azurerm_monitor_data_collection_rule.log_analytics.id
    }
  })
}
