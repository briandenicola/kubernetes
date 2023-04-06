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

# Data Collection Rules
resource "azurerm_resource_group_template_deployment" "loganalytics_datacollection" {
  depends_on = [
    azurerm_log_analytics_workspace.this
  ]

  name                = "loganalytics_datacollection-deployment"
  resource_group_name = azurerm_resource_group.this.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "dataCollectionEpRulesName" = {
      value = "${local.resource_name}-loganalytics-datacollection"
    },
    "logAnalyticsWorkspaceResourceId" = {
      value = azurerm_log_analytics_workspace.this.id
    },
    "logAnalyticsWorkspaceId" = {
      value = azurerm_log_analytics_workspace.this.workspace_id 
    }
  })
  template_content = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionEpRulesName": {
            "type": "string"
        },
        "logAnalyticsWorkspaceResourceId": {
            "type": "string"
        },
        "logAnalyticsWorkspaceId": {
            "type": "string"
        }
    },
    "variables": {},
    "resources": [
        {
          "type": "Microsoft.Insights/dataCollectionRules",
          "apiVersion": "2022-06-01",
          "name": "[parameters('dataCollectionEpRulesName')]",
          "location": "[resourceGroup().location]",
          "kind": "Linux",
          "properties": {
            "dataSources": {
                "extensions": [
                    {
                        "streams": [
                            "Microsoft-ContainerInsights-Group-Default"
                        ],
                        "extensionName": "ContainerInsights",
                        "name": "ContainerInsightsExtension"
                    }
                ]
            },
            "destinations": {
                "logAnalytics": [
                    {
                        "workspaceResourceId": "[parameters('logAnalyticsWorkspaceResourceId')]",
                        "workspaceId": "[parameters('logAnalyticsWorkspaceId')]",
                        "name": "ciworkspace"
                    }
                ]
            },
            "dataFlows": [
                {
                    "streams": [
                        "Microsoft-ContainerInsights-Group-Default"
                    ],
                    "destinations": [
                        "ciworkspace"
                    ]
                }
            ]
          }
        }

    ],
    "outputs": {
    }
}
TEMPLATE
}

#Data Collection Rules Association
resource "azurerm_resource_group_template_deployment" "loganalytics_datacollection_association" {
  depends_on = [
    azurerm_resource_group_template_deployment.azuremonitor_datacollection
  ]

  name                = "loganalytics_datacollection_association-deployment"
  resource_group_name = azurerm_resource_group.this.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "dataCollectionEpRulesName" = {
      value = "${local.resource_name}-loganalytics-datacollection"
    },
    "clusterName" = {
      value = local.aks_name
    },
    "dataCollectionRulesAssociationName" = {
      value = "${local.resource_name}-loganalytics_datacollection-association"
    }
  })
  template_content = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionEpRulesName": {
            "type": "string"
        },
        "clusterName": {
            "type": "string"
        },
        "dataCollectionRulesAssociationName": {
            "type": "string"
        }
    },
    "variables": {},
    "resources": [
        {
          "type": "Microsoft.ContainerService/managedClusters/providers/dataCollectionRuleAssociations",
          "name": "[concat(parameters('clusterName'),'/microsoft.insights/', parameters('dataCollectionRulesAssociationName'))]",
          "apiVersion": "2021-09-01-preview",
          "location": "[resourceGroup().location]",
          "properties": {
            "dataCollectionRuleId": "[resourceId('Microsoft.Insights/dataCollectionRules', parameters('dataCollectionEpRulesName'))]"
          }
        }
    ],
    "outputs": {
    }
}
TEMPLATE
}