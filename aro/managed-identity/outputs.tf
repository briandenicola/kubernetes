output "RESOURCE_GROUP" {
  value     = azurerm_resource_group.this.name
  sensitive = false
}

output "ARO_NAME" {
  value     = local.aro_name
  sensitive = false
}

output "ARO_CONSOLE_URL" {
  value = jsondecode(azapi_resource.aro_cluster.output).properties.consoleProfile.url
}

output "ARO_API_URL" {
  value = jsondecode(azapi_resource.aro_cluster.output).properties.apiserverProfile.url
}

output "ARO_CLUSTER_ID" {
  description = "The ID of the ARO cluster"
  value       = azapi_resource.aro_cluster.id
}

