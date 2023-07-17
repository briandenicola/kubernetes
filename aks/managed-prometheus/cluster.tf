data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

locals {
  kubernetes_version = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 2]
  allowed_ip_range   = ["${chomp(data.http.myip.response_body)}/32"]
}

resource "azurerm_kubernetes_cluster" "this" {
  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
    ]
  }

  name                         = local.aks_name
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  node_resource_group          = "${local.resource_name}_k8s_nodes_rg"
  dns_prefix                   = local.aks_name
  sku_tier                     = "Standard"
  automatic_channel_upgrade    = "patch"
  node_os_channel_upgrade      = "NodeImage"
  oidc_issuer_enabled          = true
  workload_identity_enabled    = true
  azure_policy_enabled         = true
  local_account_disabled       = true
  open_service_mesh_enabled    = false
  run_command_enabled          = false
  kubernetes_version           = local.kubernetes_version
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48

  api_server_access_profile {
    vnet_integration_enabled = true
    subnet_id                = azurerm_subnet.api.id
    authorized_ip_ranges     = local.allowed_ip_range
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    tenant_id              = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = [var.azure_rbac_group_object_id]
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet_identity.id
  }

  default_node_pool {
    name                = "system"
    node_count          = 1
    vm_size             = "Standard_B4ms"
    os_disk_size_gb     = 30
    vnet_subnet_id      = azurerm_subnet.nodes.id
    os_sku              = "Mariner"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    max_pods            = 60

    upgrade_settings {
      max_surge = "33%"
    }
  }

  network_profile {
    dns_service_ip      = "100.${random_integer.services_cidr.id}.0.10"
    service_cidr        = "100.${random_integer.services_cidr.id}.0.0/16"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    #network_policy      = "azure"
    load_balancer_sku = "standard"
    ebpf_data_plane   = "cilium"
  }

  maintenance_window_auto_upgrade {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Friday"
    utc_offset  = "-06:00"
    start_time  = "20:00"
  }

  maintenance_window_node_os {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Saturday"
    utc_offset  = "-06:00"
    start_time  = "20:00"
  }

  auto_scaler_profile {
    max_unready_nodes = "1"
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.this.id
    msi_auth_for_monitoring_enabled = true
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  monitor_metrics {
  }

}

