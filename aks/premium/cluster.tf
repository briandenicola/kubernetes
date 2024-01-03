data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

locals {
  #kubernetes_version = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 2]
  kubernetes_version = "1.27.7"
  allowed_ip_range   = ["${chomp(data.http.myip.response_body)}/32"]
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azapi_resource" "aks" {
  type      = "Microsoft.ContainerService/managedClusters@2023-05-02-preview"
  name      = local.aks_name
  location  = azurerm_resource_group.this.location
  parent_id = azurerm_resource_group.this.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  body = jsonencode({
    sku = {
      name = "Base"
      tier = "Premium"
    }
    properties = {

      nodeResourceGroup    = "${local.resource_name}_k8s_nodes_rg"
      kubernetesVersion    = local.kubernetes_version
      disableLocalAccounts = true
      enableRBAC           = true
      dnsPrefix            = local.aks_name

      supportPlan = "AKSLongTermSupport"
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
          name              = "systempool"
          mode              = "System"
          enableAutoScaling = true
          vmSize            = "Standard_B4ms"
          vnetSubnetID      = azurerm_subnet.nodes.id
          count             = 1
          minCount          = 1
          maxCount          = 1
          maxPods           = 40
          osDiskSizeGB      = 60
          osSKU             = "Mariner"
          type              = "VirtualMachineScaleSets"
          osType            = "Linux"
          upgradeSettings = {
            maxSurge = "33%"
          }
        }
      ]

      apiServerAccessProfile = {
        disableRunCommand     = true
        enableVnetIntegration = true
        subnetId              = azurerm_subnet.api.id
        authorizedIPRanges    = local.allowed_ip_range
      }

      autoUpgradeProfile = {
        upgradeChannel = "patch"
      }

      azureMonitorProfile = {
        metrics = {
          enabled = true
        }
      }

      identityProfile = {
        kubeletidentity = {
          resourceId = azurerm_user_assigned_identity.aks_kubelet_identity.id
          clientId   = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
          objectId   = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
        }
      }

      networkProfile = {
        dnsServiceIP      = "100.${random_integer.services_cidr.id}.0.10"
        loadBalancerSku   = "standard"
        networkPlugin     = "azure"
        networkPluginMode = "overlay"
        podCidr           = "100.${random_integer.pod_cidr.id}.0.0/16"
        serviceCidr       = "100.${random_integer.services_cidr.id}.0.0/16"
      }

      oidcIssuerProfile = {
        enabled = true
      }

      securityProfile = {
        defender = {
          logAnalyticsWorkspaceResourceId = azurerm_log_analytics_workspace.this.id
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
    }
  })
}

data "azurerm_kubernetes_cluster" "this" {
  depends_on          = [azapi_resource.aks]
  name                = local.aks_name
  resource_group_name = azurerm_resource_group.this.name
}
