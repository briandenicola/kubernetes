resource "azapi_resource" "aks" {
  type      = "Microsoft.ContainerService/managedClusters@2025-02-02-preview"
  name      = local.aks_name
  location  = azurerm_resource_group.aks.location
  parent_id = azurerm_resource_group.aks.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  body = {
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

      apiServerAccessProfile = {
        enablePrivateCluster           = true
        privateDNSZone                 = azurerm_private_dns_zone.aks_private_zone.id
        enablePrivateClusterPublicFQDN = false
        disableRunCommand              = true
        enableVnetIntegration          = true
        subnetId                       = data.azurerm_subnet.api.id
      }

      agentPoolProfiles = [
        {
          name         = "systempool"
          mode         = "System"
          vmSize       = "Standard_DS4_v2"
          count        = 3
          vnetSubnetID = var.azurerm_subnet_nodes_id
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
            logAnalyticsWorkspaceResourceID = var.azurerm_log_analytics_workspace_id
          }
        }
      }

      serviceMeshProfile = {
        mode = "Istio"
        istio = {
          components = {
            ingressGateways = [{
              enabled = true
              mode    = "Internal"
            }]
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
  }
}

data "azurerm_kubernetes_cluster" "this" {
  name                = azapi_resource.aks.name
  resource_group_name = azurerm_resource_group.aks.name
}
