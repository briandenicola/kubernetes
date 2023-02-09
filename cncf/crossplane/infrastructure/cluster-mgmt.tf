resource "azurerm_kubernetes_cluster" "controlplane" {
  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
    ]
  }

  name                              = local.controlplane_name
  resource_group_name               = azurerm_resource_group.this.name
  location                          = azurerm_resource_group.this.location
  node_resource_group               = "${local.resource_name}_controlplane_nodes_rg"
  dns_prefix                        = local.controlplane_name
  kubernetes_version                = data.azurerm_kubernetes_service_versions.current.latest_version
  sku_tier                          = "Free"
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  open_service_mesh_enabled         = true
  azure_policy_enabled              = true
  local_account_disabled            = true
  role_based_access_control_enabled = true
  automatic_channel_upgrade         = "patch"

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    tenant_id              = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = [var.azure_rbac_group_object_id]
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.controlplane_identity.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.controlplane_kubelet_identity.client_id
    object_id                 = azurerm_user_assigned_identity.controlplane_kubelet_identity.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.controlplane_kubelet_identity.id
  }

  api_server_access_profile {
    authorized_ip_ranges   = ["${chomp(data.http.myip.response_body)}/32"]
  }

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_DS4_v2"
    os_disk_size_gb     = 30
    vnet_subnet_id      = azurerm_subnet.controlplane.id
    os_sku              = "CBLMariner"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    max_pods            = 40
    upgrade_settings {
      max_surge = "25%"
    }
  }

  network_profile {
    dns_service_ip     = "100.${random_integer.controlplane_services_cidr.id}.0.10"
    service_cidr       = "100.${random_integer.controlplane_services_cidr.id}.0.0/16"
    docker_bridge_cidr = "172.17.0.1/16"
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "5m"
  }

  workload_autoscaler_profile {
    keda_enabled        = true
  }

}

data "azurerm_public_ip" "controlplane" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.controlplane.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.controlplane.node_resource_group
}
