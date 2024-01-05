output "AKS_NAMES" {
  value = [ for aks in module.cluster_resources : aks.AKS_CLUSTER_NAME ]
}

output "AKS_CLUSTER_IDS" {
  value = [ for aks in module.cluster_resources : aks.AKS_CLUSTER_ID ]
}

output "AKS_RESOURCE_GROUPS" {
  value = [ for aks in module.cluster_resources : aks.AKS_RESOURCE_GROUP ]
}

output "FLEET_NAME" {
  value = local.fleet_name
}

output "FLEET_RESOURCE_GROUP" {
  value = azurerm_resource_group.this.name
}