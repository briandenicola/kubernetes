output "AKS_RESOURCE_GROUP" {
  value     = var.aks_cluster.resource_group.name
  sensitive = false
}

output "AKS_CLUSTER_NAME" {
  value     = local.aks_name
  sensitive = false
}

output "AKS_NODE_RESOURCE_GROUP" {
  value     = local.aks_node_rg_name
  sensitive = false
}