resource "azapi_resource" "aks" {
  
  depends_on = [ 
    azurerm_subnet.api,
    azurerm_subnet.nodes,
    azurerm_subnet_nat_gateway_association.nodes,
    azurerm_subnet_nat_gateway_association.pe,
    azurerm_user_assigned_identity.aks_identity,
    azurerm_user_assigned_identity.aks_kubelet_identity,
    azurerm_role_assignment.aks_role_assignemnt_msi,
    azurerm_role_assignment.aks_role_assignemnt_network
  ]

  type      = "Microsoft.ContainerService/managedClusters@2025-09-02-preview"
  name      = var.aks_cluster.name
  location  = local.location
  parent_id = azurerm_resource_group.this.id

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
      kubernetesVersion    = var.aks_cluster.kubernetes_version
      dnsPrefix            = var.aks_cluster.name
      enableRBAC           = true
      disableLocalAccounts = true
      nodeResourceGroup    = local.aks_node_rg_name

      aadProfile = {
        enableAzureRBAC = true
        managed         = true
        tenantID        = data.azurerm_client_config.current.tenant_id
      }

      linuxProfile = {
        adminUsername = "manager"
        ssh = {
          publicKeys = [{
            keyData = var.aks_cluster.public_key_openssh
          }]
        }
      }
      
      nodeResourceGroupProfile = {
        restrictionLevel = "ReadOnly"
      }

      networkProfile = {
        networkPlugin     = "azure"
        networkPluginMode = "overlay"
        loadBalancerSku   = "standard"
        networkPolicy     = "cilium"
        networkDataplane  = "cilium"
        outboundType      = "userAssignedNATGateway"

        serviceCidr  = "100.${random_integer.services_cidr.id}.0.0/16"
        dnsServiceIP = "100.${random_integer.services_cidr.id}.0.10"
        podCidr      = "100.${random_integer.pod_cidr.id}.0.0/16"

        advancedNetworking = {
          enabled = true,
          observability = {
            enabled = true
          }
          security = {
            enabled = true
            advancedNetworkPolicies = "L7"
            transitEncryption = {
              type = "WireGuard"
            }
          }
        }
      }

      agentPoolProfiles = [{
        name              = "system"
        mode              = "System"
        minCount          = 1
        maxCount          = var.aks_cluster.nodes.count + 2
        count             = var.aks_cluster.nodes.count
        vmSize            = var.aks_cluster.nodes.sku
        availabilityZones = var.aks_cluster.zones
        osDiskSizeGB      = 127
        vnetSubnetID      = azurerm_subnet.nodes.id
        osType            = "Linux"
        osSKU             = "AzureLinux"
        type              = "VirtualMachineScaleSets"
        maxPods           = 250
        enableAutoScaling = true
        upgradeSettings = {
          maxSurge                  = "33%"
          drainTimeoutInMinutes     = 10
          nodeSoakDurationInMinutes = 1
          undrainableNodeBehavior   = "Cordon"
        }
        securityProfile = {
          sshAccess = "Disabled"
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
          config = {
              enableSecretRotation = "true"
              rotationPollInterval = "2m"
          }       
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
        appMonitoring = {
          autoInstrumentation = {
            enabled = true
          }
          openTelemetryLogs = {
            enabled = true
          }
          openTelemetryMetrics = {
            enabled = true
          }
        }
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
        verticalPodAutoscaler = {
          enabled = true
        }
      }

      oidcIssuerProfile = {
        enabled = true
      }

      apiServerAccessProfile = {
        enablePrivateCluster           = false
        enablePrivateClusterPublicFQDN = false
        disableRunCommand              = true
        enableVnetIntegration          = true
        subnetId                       = azurerm_subnet.api.id
        authorizedIPRanges = [
          var.aks_cluster.allowed_ip_ranges
        ]
      }

      serviceMeshProfile = var.aks_cluster.istio.enabled ? {
        mode = "Istio"
        istio = {
          revisions = [
            var.aks_cluster.istio.version
          ]
          components = {
            ingressGateways = [{
                enabled = true
                mode    = "Internal"
            }]
          }
        }
      } : null

      storageProfile = {
        blobCSIDriver = {
          enabled = true
        }
        diskCSIDriver = {
          enabled = true
          version = "v1"
        }
        fileCSIDriver = {
          enabled = true
        }
      }
    }
  }
}

data azurerm_kubernetes_cluster this {
  name                = azapi_resource.aks.name
  resource_group_name = azurerm_resource_group.this.name
} 
