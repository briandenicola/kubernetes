resource "azapi_resource" "aro_cluster" {
  depends_on = [
    azurerm_resource_group.this,
    time_sleep.wait_for_rbac
  ]
  type      = "Microsoft.RedHatOpenShift/openShiftClusters@2024-08-12-preview"
  name      = local.aro_name
  location  = azurerm_resource_group.this.location
  parent_id = azurerm_resource_group.this.id

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.cluster.id
    ]
  }
  
  timeouts {
    create = "40m"
  }

  body = {
    properties = {
      clusterProfile = {
        domain               = var.domain
        version              = var.cluster_version
        pullSecret           = var.pull_secret
        resourceGroupId      = local.aro_managed_resource_group
        fipsValidatedModules = var.fips_enabled ? "Enabled" : "Disabled"

      }

      #Azure Red Hat OpenShift uses 100.64.0.0/16, 169.254.169.0/29, and 100.88.0.0/16 IP address ranges internally. 
      #Do not include this '100.64.0.0/16' IP address range in any other CIDR definitions in your cluster.

      networkProfile = {
        podCidr          = "100.${random_integer.pod_cidr.id}.0.0/16"
        serviceCidr      = "100.${random_integer.services_cidr.id}.0.0/16"
        outboundType     = "Loadbalancer"  #"UserDefinedRouting"
        preconfiguredNSG = "Disabled"      #"Enabled"
      }

      masterProfile = {
        vmSize           = local.main_vm_size
        subnetId         = azurerm_subnet.master_subnet.id
        encryptionAtHost = "Enabled"
        #diskEncryptionSetId
      }

      workerProfiles = [
        {
          name             = "worker"
          vmSize           = local.worker_vm_size
          diskSizeGB       = local.worker_os_disk_size_gb
          subnetId         = azurerm_subnet.worker_subnet.id
          count            = local.vm_node_count
          encryptionAtHost = "Enabled"
          #diskEncryptionSetId
        }
      ]

      apiserverProfile = {
        visibility = "Private"
      }

      ingressProfiles = [{
        name       = "default"
        visibility = "Private"
      }]

      platformWorkloadIdentityProfile = {
        platformWorkloadIdentities = {
          cloud-controller-manager = {
            resourceId = azurerm_user_assigned_identity.cloud_controller_manager.id
          },
          ingress = {
            resourceId = azurerm_user_assigned_identity.ingress.id
          },
          machine-api = {
            resourceId = azurerm_user_assigned_identity.machine_api.id
          },
          cloud-network-config = {
            resourceId = azurerm_user_assigned_identity.cloud_network_config.id
          },
          image-registry = {
            resourceId = azurerm_user_assigned_identity.image_registry.id
          },
          file-csi-driver = {
            resourceId = azurerm_user_assigned_identity.file_csi_driver.id
          },
          disk-csi-driver = {
            resourceId = azurerm_user_assigned_identity.disk_csi_driver.id
          },
          aro-operator = {
            resourceId = azurerm_user_assigned_identity.operator.id
          }
        }
      }
    }
  }
}
