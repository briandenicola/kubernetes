data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

resource "azapi_resource" "aks" {
  type            = "Microsoft.ContainerService/managedClusters@2022-08-03-preview"
  name            = local.aks_name
  location        = azurerm_resource_group.this.location
  parent_id       = azurerm_resource_group.this.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  body = jsonencode({
    properties = {

      nodeResourceGroup     = "${local.resource_name}_k8s_nodes_rg"
      kubernetesVersion     = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions)-2]
      disableLocalAccounts  = true 
      enableRBAC            = true
      dnsPrefix             = local.aks_name

      aadProfile = {
        adminGroupObjectIDs = [var.azure_rbac_group_object_id]
        enableAzureRBAC     = true
        managed             = true
        tenantID            = data.azurerm_client_config.current.tenant_id
      }

      addonProfiles = {
        azurepolicy = {
          enabled = true
        }
      
        omsagent = {
          enabled = true
          config = {
            logAnalyticsWorkspaceResourceID = azurerm_log_analytics_workspace.this.id
          }
        }
      }

      agentPoolProfiles = [
        {
          name                = "default"
          enableAutoScaling   = true
          vmSize              = "Standard_DS2_v2"
          vnetSubnetID        = azurerm_subnet.nodes.id
          count               = 3
          minCount            = 3
          maxCount            = 9
          maxPods             = 40
          osDiskSizeGB        = 30
          osSKU               = "CBLMariner"
          type                = "VirtualMachineScaleSets"
          osDiskType          = "Ephemeral"
          osType              = "Linux"
          mode                = "System"
          upgradeSettings     = {
            maxSurge          = "33%"
          }
        }
      ]

      apiServerAccessProfile = {
        //authorizedIPRanges              = ["${chomp(data.http.myip.response_body)}/32"]
        disableRunCommand               = true
        enableVnetIntegration           = true
        enablePrivateCluster            = true
        enablePrivateClusterPublicFQDN  = false
        privateDNSZone                  = azurerm_private_dns_zone.aks_private_zone.id
        subnetId                        = azurerm_subnet.api.id
      }

      autoUpgradeProfile = {
        upgradeChannel      = "patch"
      }

      azureMonitorProfile = {
        metrics = {
          enabled           = true
        }
      }

      identityProfile = {
          kubeletidentity = {
            resourceId  = azurerm_user_assigned_identity.aks_kubelet_identity.id
            clientId    = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
            objectId    = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
          }
      }

      networkProfile = {
        dnsServiceIP          = "100.${random_integer.services_cidr.id}.0.10"
        dockerBridgeCidr      = "172.17.0.1/16"
        loadBalancerSku       = "standard"
        networkPlugin         = "azure"
        networkPluginMode     = "overlay"
        podCidr               = "100.${random_integer.pod_cidr.id}.0.0/16"
        serviceCidr           = "100.${random_integer.services_cidr.id}.0.0/16"
      }

      oidcIssuerProfile = {
        enabled               = true
      }

      securityProfile = {
        defender = {
          logAnalyticsWorkspaceResourceId = azurerm_log_analytics_workspace.this.id
          securityMonitoring = {
            enabled           = true
          }
        }
        imageCleaner = {
          enabled             = true
          intervalHours       = 48
        }
        workloadIdentity = {
          enabled             = true
        }
      }

      workloadAutoScalerProfile = {
        keda = {
          enabled             = true
        }
      }

      storageProfile = {
        blobCSIDriver = {
          enabled             = true
        }
        diskCSIDriver = {
          enabled             = true
          version             = "v1"
        }
        fileCSIDriver = {
          enabled             = true
        }
      }      
    }
  })
}
