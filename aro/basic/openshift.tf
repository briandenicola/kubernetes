resource "azurerm_redhat_openshift_cluster" "this" {
  depends_on = [
    azurerm_role_assignment.aro_cluster_service_principal_network_contributor,
    azurerm_role_assignment.aro_resource_provider_service_principal_network_contributor
  ]

  name                = local.aro_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  service_principal {
    client_id     = azuread_application.this.client_id
    client_secret = azuread_application_password.this.value
  }

  main_profile {
    vm_size   = local.main_vm_size
    subnet_id = azurerm_subnet.master_subnet.id
  }

  cluster_profile {
    domain                      = var.domain
    version                     = local.aro_version
    fips_enabled                = false
    managed_resource_group_name = local.aro_managed_resource_group
  }

  network_profile {
    pod_cidr     = "100.${random_integer.pod_cidr.id}.0.0/16"
    service_cidr = "100.${random_integer.services_cidr.id}.0.0/16"
  }

  api_server_profile {
    visibility = "Private"
  }

  ingress_profile {
    visibility = "Private"
  }

  worker_profile {
    vm_size      = local.worker_vm_size
    disk_size_gb = local.worker_os_disk_size_gb
    node_count   = local.vm_node_count
    subnet_id    = azurerm_subnet.worker_subnet.id
  }


}
