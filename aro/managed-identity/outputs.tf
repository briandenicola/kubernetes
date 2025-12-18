output "RESOURCE_GROUP" {
  value     = azurerm_resource_group.this.name
  sensitive = false
}

output "ARO_NAME" {
  value     = local.aro_name
  sensitive = false
}

output "ARO_LOCATION" {
  value     = local.location
  sensitive = false
}

output "ARO_CONSOLE_URL" {
  value = azapi_resource.aro_cluster.output.properties.consoleProfile.url
}

output "ARO_API_URL" {
  value = azapi_resource.aro_cluster.output.properties.apiserverProfile.url
}

output "ARO_API_IP" {
  value = azapi_resource.aro_cluster.output.properties.apiserverProfile.ip
}

output "ARO_OIDC_ISSUER_URL" {
  value = azapi_resource.aro_cluster.output.properties.clusterProfile.oidcIssuer
}

output "ARO_CONSOLE_IP" {
  value = azapi_resource.aro_cluster.output.properties.ingressProfiles[0].ip
}

output "ARO_CLUSTER_ID" {
  value = azapi_resource.aro_cluster.id
}

