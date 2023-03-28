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

//Issue with Unknown property that I could not find so moved to ARM Template deployment
/*resource "azapi_resource" "data_collection_rules" {
  depends_on = [
    azapi_resource.azure_monitor_workspace,
    azurerm_monitor_data_collection_endpoint.this
  ]

  type      = "Microsoft.Insights/dataCollectionRules@2021-09-01-preview"
  name      = "${local.resource_name}-workspace"
  parent_id = azurerm_resource_group.this.id
  location  = azurerm_resource_group.this.location

  schema_validation_enabled = false

  body = jsonencode({
    kind = "Linux"
    properties = {
      dataCollectionEndpointId = azurerm_monitor_data_collection_endpoint.this.id,
      dataSources = {
        prometheusForwarder = [{
          streams = ["Microsoft-PrometheusMetrics"]
          labelIncludeFilter = {}
          name    = "PrometheusDataSource"
        }]
      },
      destinations = {
        monitoringAccounts = {
          name              = "MonitoringAccount1"
          accountResourceId = local.am_workspace_id
        }
      },
      dataFlows = [{
        streams      = ["Microsoft-PrometheusMetrics"],
        destinations = ["MonitoringAccount1"]
      }],
    }
  })
}*/


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

/*
resource "azapi_resource" "azurerm_monitor_data_collection_rule_association" {
  type = "Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview"
  name = "${local.resource_name}-datacollection-rules-association"
  parent_id = azurerm_kubernetes_cluster.this.id
  body = jsonencode({
    properties = {
      dataCollectionRuleId = data.azurerm_monitor_data_collection_rule.data_collection_rules.id
    }
  })
}*/


#Data Collection Prometheus Rule Group
resource "azapi_resource" "prometheus_rule_groups" {
  depends_on = [
    azurerm_resource_group_template_deployment.data_collection_rules
  ]

  type      = "Microsoft.AlertsManagement/prometheusRuleGroups@2021-07-22-preview"
  name      = "SimplePrometheusRules"
  parent_id = azurerm_resource_group.this.id
  location  = azurerm_resource_group.this.location

  body = jsonencode({
    properties = {
      scopes  = [ local.am_workspace_id ]
      enabled = true,
      clusterName = local.aks_name
      interval = "PT1M"
      rules = [
        {
          record = "instance:node_num_cpu:sum"
          expression =  "count without (cpu, mode) (  node_cpu_seconds_total{job=\"node\",mode=\"idle\"})"
        },
        {
          record = "instance:node_cpu_utilisation:rate5m"
          expression = "1 - avg without (cpu) (  sum without (mode) (rate(node_cpu_seconds_total{job=\"node\", mode=~\"idle|iowait|steal\"}[5m])))"
        },
        {
          record = "instance:node_load1_per_cpu:ratio"
          expression = "(node_load1{job=\"node\"}/  instance:node_num_cpu:sum{job=\"node\"})"
        },
        {
          record = "instance:node_memory_utilisation:ratio"
          expression =  "1 - ((node_memory_MemAvailable_bytes{job=\"node\"} or  (node_memory_Buffers_bytes{job=\"node\"} + node_memory_Cached_bytes{job=\"node\"} + node_memory_MemFree_bytes{job=\"node\"} + node_memory_Slab_bytes{job=\"node\"}))/ node_memory_MemTotal_bytes{job=\"node\"})"
        },
        {
          record = "instance:node_vmstat_pgmajfault:rate5m"
          expression = "rate(node_vmstat_pgmajfault{job=\"node\"}[5m])"
        },
        {
          record = "instance_device:node_disk_io_time_seconds:rate5m"
          expression = "rate(node_disk_io_time_seconds_total{job=\"node\", device!=\"\"}[5m])"
        },
        {
          record = "instance_device:node_disk_io_time_weighted_seconds:rate5m"
          expression = "rate(node_disk_io_time_weighted_seconds_total{job=\"node\", device!=\"\"}[5m])"
        },
        {
          record = "instance:node_network_receive_bytes_excluding_lo:rate5m"
          expression = "sum without (device) (  rate(node_network_receive_bytes_total{job=\"node\", device!=\"lo\"}[5m]))"
        },
        {
          record = "instance:node_network_transmit_bytes_excluding_lo:rate5m"
          expression = "sum without (device) (  rate(node_network_transmit_bytes_total{job=\"node\", device!=\"lo\"}[5m]))"
        },
        {
          record = "instance:node_network_receive_drop_excluding_lo:rate5m"
          expression = "sum without (device) (  rate(node_network_receive_drop_total{job=\"node\", device!=\"lo\"}[5m]))"
        },
        {
          record = "instance:node_network_transmit_drop_excluding_lo:rate5m"
          expression = "sum without (device) (  rate(node_network_transmit_drop_total{job=\"node\", device!=\"lo\"}[5m]))"
        }
      ]
    }
  })
}