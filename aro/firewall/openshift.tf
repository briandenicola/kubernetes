resource "azapi_resource" "aro_cluster" {
  depends_on = [
    azurerm_resource_group.this,
    azurerm_subnet_network_security_group_association.master_subnet,
    azurerm_subnet_network_security_group_association.worker_subnet,
    time_sleep.wait_for_rbac  
  ]

  lifecycle {
    ignore_changes = [
      body.clusterProfile.resourceGroupId
    ]  
  }

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
        outboundType     = "UserDefinedRouting"
        preconfiguredNSG = "Enabled"      
      }

      masterProfile = {
        vmSize           = local.main_vm_size
        subnetId         = azurerm_subnet.master_subnet.id
        encryptionAtHost = var.host_encryption_enabled ? "Enabled" : "Disabled"
        #diskEncryptionSetId
      }

      workerProfiles = [
        {
          name             = "worker"
          vmSize           = local.worker_vm_size
          diskSizeGB       = local.worker_os_disk_size_gb
          subnetId         = azurerm_subnet.worker_subnet.id
          count            = local.vm_node_count
          encryptionAtHost = var.host_encryption_enabled ? "Enabled" : "Disabled"
          #diskEncryptionSetId
        }
      ]

      apiserverProfile = {
        visibility = var.cluster_type
      }

      ingressProfiles = [{
        name       = "default"
        visibility =  var.cluster_type
      }]

      platformWorkloadIdentityProfile = {
        platformWorkloadIdentities = {
          cloud-controller-manager = {
            resourceId = azurerm_user_assigned_identity.cloud_controller_manager.id
          }
          ingress = {
            resourceId = azurerm_user_assigned_identity.ingress.id
          }
          machine-api = {
            resourceId = azurerm_user_assigned_identity.machine_api.id
          }
          cloud-network-config = {
            resourceId = azurerm_user_assigned_identity.cloud_network_config.id
          }
          image-registry = {
            resourceId = azurerm_user_assigned_identity.image_registry.id
          }
          file-csi-driver = {
            resourceId = azurerm_user_assigned_identity.file_csi_driver.id
          }
          disk-csi-driver = {
            resourceId = azurerm_user_assigned_identity.disk_csi_driver.id
          }
          aro-operator = {
            resourceId = azurerm_user_assigned_identity.operator.id
          }
        }
      }
    }
  }

  response_export_values = [
    "properties.clusterProfile.oidcIssuer",
    "properties.consoleProfile.url",
    "properties.apiserverProfile.url"
  ]
}
