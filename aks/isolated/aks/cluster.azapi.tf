resource "azapi_resource" "aks" {
  depends_on = [
    azurerm_role_assignment.acr_pullrole_node,
    azurerm_role_assignment.aks_role_assignemnt_dns,
    azurerm_role_assignment.aks_role_assignemnt_msi,
    azurerm_role_assignment.aks_role_assignemnt_network
  ]

  type      = "Microsoft.ContainerService/managedClusters@2025-03-02-preview"
  name      = local.aks_name
  location  = var.aks_cluster.location
  parent_id = var.aks_cluster.resource_group.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  body = {
    sku = {
      name = "Base"
      tier = "Standard"
    }
    properties = {
      kubernetesVersion    = local.kubernetes_version
      dnsPrefix            = local.aks_name
      enableRBAC           = true
      disableLocalAccounts = true 
      nodeResourceGroup    = "${local.aks_name}_nodes_rg"

      aadProfile = {
        enableAzureRBAC = true
        managed         = true
        tenantID        = data.azurerm_client_config.current.tenant_id
      }

      linuxProfile = {
        adminUsername = "manager"
        ssh = {
          publicKeys = [{
            keyData = tls_private_key.rsa.public_key_openssh
          }]
        }
      }

      networkProfile = {
        networkPlugin     = "azure"
        networkPluginMode = "overlay"
        loadBalancerSku   = "standard"
        networkPolicy     = "cilium"
        networkDataplane  = "cilium"
        outboundType      = "none"
        serviceCidr       = "100.${random_integer.services_cidr.id}.0.0/16"
        dnsServiceIP      = "100.${random_integer.services_cidr.id}.0.10"
        podCidr           = "100.${random_integer.pod_cidr.id}.0.0/16"
        advancedNetworking = {
          observability = {
            enabled = true
          }
        }
      }

      bootstrapProfile = {
        artifactSource = "Cache"
        containerRegistryId = var.aks_cluster.container_registry.id
      }

      agentPoolProfiles = [{
        name              = "system"
        mode              = "System"
        count             = var.aks_cluster.nodes.count
        vmSize            = var.aks_cluster.nodes.sku
        availabilityZones = local.aks_zones
        osDiskSizeGB      = 127
        vnetSubnetID      = var.aks_cluster.vnet.node_subnet.id
        osType            = "Linux"
        osSKU             = var.aks_cluster.nodes.os
        type              = "VirtualMachineScaleSets"
        maxPods           = 110
        enableAutoScaling = false
        upgradeSettings = {
          maxSurge = "33%"
        }
      }]

      addonProfiles = {
        omsagent = {
          enabled = true
          config = {
            logAnalyticsWorkspaceResourceID = var.aks_cluster.logs.workspace_id
          }
        }
        azurePolicy = {
          enabled = true
        }
        azureKeyvaultSecretsProvider = {
          enabled = true
        }
      }

      autoUpgradeProfile = {
        nodeOSUpgradeChannel = "NodeImage"
        upgradeChannel       = "patch"
      }

      metricsProfile = {
        costAnalysis = {
          enabled = true
        }
      }

      azureMonitorProfile = {
        containerInsights = {
          enabled                         = true
          logAnalyticsWorkspaceResourceId = var.aks_cluster.logs.workspace_id
        }
        metrics = {
          enabled = true
        }
      }

      securityProfile = {
        defender = {
          logAnalyticsWorkspaceResourceId = var.aks_cluster.logs.workspace_id
          securityMonitoring = {
            enabled = true
          }
        }
        imageCleaner = {
          enabled       = true
          intervalHours = 48
        }
        workloadIdentity = {
          enabled = true
        }
      }

      workloadAutoScalerProfile = {
        keda = {
          enabled = true
        }
      }

      oidcIssuerProfile = {
        enabled = true
      }

      apiServerAccessProfile = {
        enablePrivateCluster           = true
        privateDNSZone                 = azurerm_private_dns_zone.aks_private_zone.id
        enablePrivateClusterPublicFQDN = false
        disableRunCommand              = false
        enableVnetIntegration          = true
        subnetId                       = var.aks_cluster.vnet.mgmt_subnet.id
      }

      serviceMeshProfile = {
        istio = {

          components = {
            ingressGateways = [
              {
                enabled = true
                mode    = "Internal"
              }
            ]
          }
          revisions = var.aks_cluster.istio.version
        }
        mode = "Istio"
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "diag"
  target_resource_id         = azapi_resource.aks.id
  log_analytics_workspace_id = var.aks_cluster.logs.workspace_id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "kube-audit-admin"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  enabled_log {
    category = "guard"
  }

  metric {
    category = "AllMetrics"
  }
}
