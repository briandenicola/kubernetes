
# Data Collection Endpoint
resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                          = "${local.resource_name}-azuremonitor-datacollection-ep"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  kind                          = "Linux"
  public_network_access_enabled = true
}

# Data Collection Rules
resource "azurerm_resource_group_template_deployment" "azuremonitor_datacollection" {
  depends_on = [
    azapi_resource.azure_monitor_workspace,
    azurerm_monitor_data_collection_endpoint.this
  ]

  name                = "azuremonitor_datacollection-deployment"
  resource_group_name = azurerm_resource_group.this.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "dataCollectionEpRulesName" = {
      value = "${local.resource_name}-azuremonitor-datacollection-rules"
    },
    "dataCollectionEndpointResourceId" = {
      value = azurerm_monitor_data_collection_endpoint.this.id
    },
    "azureMonitorWorkspaceResourceId" = {
      value = local.am_workspace_id
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
        "dataCollectionEndpointResourceId": {
            "type": "string"
        },
        "azureMonitorWorkspaceResourceId": {
            "type": "string"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "apiVersion": "2021-09-01-preview",
            "name": "[parameters('dataCollectionEpRulesName')]",
            "location": "[resourceGroup().location]",
            "kind": "Linux",
            "properties": {
                "dataCollectionEndpointId": "[parameters('dataCollectionEndpointResourceId')]",
                "dataFlows": [{
                    "destinations": ["MonitoringAccount1"],
                    "streams": ["Microsoft-PrometheusMetrics"]
                }],
                "dataSources": {
                    "prometheusForwarder": [{
                        "name": "PrometheusDataSource",
                        "streams": [ "Microsoft-PrometheusMetrics" ],
                        "labelIncludeFilter": {}
                    }]
                },
                "destinations": {
                    "monitoringAccounts": [{
                        "accountResourceId": "[parameters('azureMonitorWorkspaceResourceId')]",
                        "name": "MonitoringAccount1"
                    }]
                }
            }
        }

    ],
    "outputs": {
    }
}
TEMPLATE
}

#Data Collection Rules Association
resource "azurerm_resource_group_template_deployment" "data_collection_rules_association" {
  depends_on = [
    azurerm_resource_group_template_deployment.azuremonitor_datacollection
  ]

  name                = "data_collection_rules_association-deployment"
  resource_group_name = azurerm_resource_group.this.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "dataCollectionEpRulesName" = {
      value = "${local.resource_name}-azuremonitor-datacollection"
    },
    "clusterName" = {
      value = local.aks_name
    },
    "dataCollectionRulesAssociationName" = {
      value = "${local.resource_name}-azuremonitor-datacollection-association"
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
