resource "azapi_resource" "aks" {
  type      = "Microsoft.ContainerService/managedClusters@2024-04-02-preview"
  name      = local.aks_name
  location  = azurerm_resource_group.this.location
  parent_id = azurerm_resource_group.this.id

  identity {
    type = "SystemAssigned"
  }

  body = jsonencode({
    kind = "Automatic"
    sku = {
      name = "Automatic"
      tier = "Standard"
    }
    properties = {
      enableRBAC           = true
      supportPlan          = "KubernetesOfficial"
      nodeResourceGroup    = "${local.aks_name}_nodes_rg"
      disableLocalAccounts = true

      nodeResourceGroupProfile = {
        restrictionLevel = "ReadOnly"
      }

      nodeProvisioningProfile = {
        mode = "Auto"
      }

      agentPoolProfiles = [
        {
          name   = "systempool"
          mode   = "System"
          vmSize = "Standard_DS4_v2"
          count  = 3

          securityProfile = {
            sshAccess = "Disabled"
          }
        }
      ]

      autoUpgradeProfile = {
        upgradeChannel       = "stable"
        nodeOSUpgradeChannel = "NodeImage"
      }

      addonProfiles = {
        omsagent = {
          enabled = true
          config = {
            logAnalyticsWorkspaceResourceID = azurerm_log_analytics_workspace.this.id
          }
        }
      }

      serviceMeshProfile = {
        mode = "Istio"
        istio = {
          components = {
            ingressGateways = [{
              enabled = true
              mode    = "External"
            }]
          }
        }
      }

      networkProfile = {
        advancedNetworking = {
          observability = {
            enabled = true
          }
        }
      }
      
      azureMonitorProfile = {
        metrics = {
          enabled = true
          kubeStateMetrics = {
            metricLabelsAllowlist      = ""
            metricAnnotationsAllowList = ""
          }
        }
      }
    }
  })
}

resource "azapi_resource" "maintenance_configurations" {
  depends_on = [ 
    azapi_resource.aks 
  ]
  
  type      = "Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-04-02-preview"
  name      = "aksManagedAutoUpgradeSchedule"
  parent_id = azapi_resource.aks.id

  body = jsonencode({
    properties = {
      maintenanceWindow = {
        schedule = {
          weekly = {
            intervalWeeks = 1,
            dayOfWeek     = "Saturday"
          }
        }
        durationHours = 4
        utcOffset     = "+00:00"
        startDate     = "2024-07-12"
        startTime     = "22:00"
      }
    }
  })
}
