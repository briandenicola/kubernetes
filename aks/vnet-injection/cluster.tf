module "cluster" {
  source                             = "../modules/aks.v4"
  region                             = var.region
  authorized_ip_ranges               = local.authorized_ip_ranges
  resource_name                      = local.resource_name
  public_key_openssh                 = tls_private_key.rsa.public_key_openssh
  tags                               = var.tags
  kubernetes_version                 = local.k8s_version
  sdlc_environment                   = local.environment_type
  vm_sku                             = var.vm_size
  vm_os                              = "Ubuntu"
  node_count                         = var.node_count
  enable_mesh                        = false
  azurerm_log_analytics_workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
}

#Virtual Network Injection
#Equivalent: az aks update -n $AKS_CLUSTER_NAME -g AKS_CLUSTER_RG --enable-apiserver-vnet-integration --apiserver-subnet-id $local.api_subnet_cidir
locals {
  api_subnet_cidir     = cidrsubnet(module.cluster.VNET_CIDR, 8, 2)
}
# resource "azurerm_subnet" "api" {
#   depends_on = [
#     module.cluster
#   ]  
#   name                            = "api-server"
#   resource_group_name             = module.cluster.AKS_RESOURCE_GROUP
#   virtual_network_name            = module.cluster.VNET_NAME
#   address_prefixes                = [local.api_subnet_cidir]
 
#   delegation {
#     name = "aks-delegation"

#     service_delegation {
#       name = "Microsoft.ContainerService/managedClusters"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#       ]
#     }
#   }
# }

# resource "azapi_update_resource" "vnet_injection" {
#   depends_on = [
#     module.cluster,
#     azurerm_subnet.api
#   ]

#   type        = "Microsoft.ContainerService/managedClusters@2025-03-02-preview"
#   resource_id = module.cluster.AKS_CLUSTER_ID

#   body = {
#     properties = {
#       apiServerAccessProfile = {
#         enableVnetIntegration = true
#         subnetId              = azurerm_subnet.api.id
#       }      
#     }
#   }
# }