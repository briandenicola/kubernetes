#Data Collection Endpoint
resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                          = "${local.resource_name}-datacollection-ep"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  kind                          = "Linux"
  public_network_access_enabled = true
}

#Azure Monitor Workspace
resource "azapi_resource" "azure_monitor_workspace" {
  type      = "microsoft.monitor/accounts@2021-06-03-preview"
  name      = "${local.resource_name}-workspace"
  parent_id = azurerm_resource_group.this.id

  location = azurerm_resource_group.this.location

  body = jsonencode({
  })
}

locals {
  am_workspace_id = "${data.azurerm_subscription.current.id}/resourcegroups/${azurerm_resource_group.this.name}/providers/microsoft.monitor/accounts/${local.resource_name}-workspace"
}

#Azure Grafana Service
resource "azurerm_dashboard_grafana" "this" {
  depends_on = [
    azapi_resource.azure_monitor_workspace
  ]

  name                              = "${local.resource_name}-grafana"
  resource_group_name               = azurerm_resource_group.this.name
  location                          = azurerm_resource_group.this.location
  sku                               = "Standard"
  zone_redundancy_enabled           = true
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = local.am_workspace_id
  }
}

#Data Collection Rules
resource "azurerm_resource_group_template_deployment" "data_collection_rules" {
  depends_on = [
    azapi_resource.azure_monitor_workspace,
    azurerm_monitor_data_collection_endpoint.this
  ]

  name                = "data_collection_rules-deployment"
  resource_group_name = azurerm_resource_group.this.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "dataCollectionEpRulesName" = {
      value = "${local.resource_name}-datacollection-rules"
    },
    "dataCollectionEndpointResourceId" = {
      value =  azurerm_monitor_data_collection_endpoint.this.id
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

# Data Collection association 
data "azurerm_monitor_data_collection_rule" "data_collection_rules" {
  depends_on = [
    azurerm_resource_group_template_deployment.data_collection_rules
  ]
  name                = "${local.resource_name}-datacollection-rules"
  resource_group_name = azurerm_resource_group.this.name
}

#Data Collection Rules Association
resource "azurerm_resource_group_template_deployment" "data_collection_rules_association" {
  depends_on = [
    azurerm_resource_group_template_deployment.data_collection_rules
  ]

  name                = "data_collection_rules_association-deployment"
  resource_group_name = azurerm_resource_group.this.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "dataCollectionEpRulesName" = {
      value = "${local.resource_name}-datacollection-rules"
    },
    "clusterName" = {
      value = local.aks_name
    },
    "dataCollectionRulesAssociationName" = {
      value = "${local.resource_name}-datacollection-rules-association"
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