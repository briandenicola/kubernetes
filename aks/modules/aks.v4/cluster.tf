data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

locals {
  zones = var.region == "northcentralus" || var.region == "canadaeast" ? null : var.zones
  authorized_ip_ranges = "${concat(var.authorized_ip_ranges, ["${azurerm_public_ip.this.ip_address}/32", "${azurerm_public_ip_prefix.this.ip_prefix}"])}"
}

resource "azurerm_kubernetes_cluster" "this" {
  depends_on = [
    azurerm_user_assigned_identity.aks_identity,
    azurerm_user_assigned_identity.aks_kubelet_identity,
    #azurerm_subnet.api,
    azurerm_subnet.nodes,
    azurerm_subnet_nat_gateway_association.nodes,
    azurerm_role_assignment.aks_role_assignemnt_network,
    azurerm_role_assignment.aks_role_assignemnt_msi
  ]

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
      kubernetes_version
    ]
  }

  name                         = local.aks_name
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  node_resource_group          = local.aks_node_rg_name
  kubernetes_version           = var.kubernetes_version
  dns_prefix                   = local.aks_name
  sku_tier                     = "Standard"
  oidc_issuer_enabled          = true
  workload_identity_enabled    = true
  azure_policy_enabled         = true
  local_account_disabled       = true
  open_service_mesh_enabled    = false
  run_command_enabled          = false
  cost_analysis_enabled        = true
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48

  automatic_upgrade_channel    = "patch"
  node_os_upgrade_channel      = "SecurityPatch"

  api_server_access_profile {
    authorized_ip_ranges = local.authorized_ip_ranges
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  linux_profile {
    admin_username = "manager"
    ssh_key {
      key_data = var.public_key_openssh
    }
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet_identity.id
  }

  default_node_pool {
    name                         = "system"
    node_count                   = var.node_count
    vm_size                      = var.vm_sku
    zones                        = local.zones
    os_disk_size_gb              = 127
    vnet_subnet_id               = azurerm_subnet.nodes.id
    os_sku                       = var.vm_os
    type                         = "VirtualMachineScaleSets"
    auto_scaling_enabled         = true
    min_count                    = 1
    max_count                    = var.node_count
    max_pods                     = 250
    node_labels                  = tomap(var.node_labels)
    only_critical_addons_enabled = var.only_critical_addons_enabled

    upgrade_settings {
      max_surge = "25%"
    }
  }

  network_profile {
    dns_service_ip      = "100.${random_integer.services_cidr.id}.0.10"
    service_cidr        = "100.${random_integer.services_cidr.id}.0.0/16"
    pod_cidr            = "100.${random_integer.pod_cidr.id}.0.0/16"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
    network_data_plane  = var.network_policy_engine
    network_policy      = var.network_policy_engine
    outbound_type       = "userAssignedNATGateway"
  }

  dynamic "service_mesh_profile" {
    for_each = var.enable_mesh == true ? [true] : []

    content {
      mode                             = "Istio"
      internal_ingress_gateway_enabled = true
      revisions                        = local.istio_version
    }
  }

  dynamic "storage_profile" {
    for_each = var.enable_csi_drivers == true ? [true] : []

    content {
      blob_driver_enabled = true
      disk_driver_enabled = true
      file_driver_enabled = true
    }
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

  workload_autoscaler_profile {
    keda_enabled                    = true
    vertical_pod_autoscaler_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id      = var.azurerm_log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = var.msi_auth_for_monitoring_enabled
  }

  monitor_metrics {
  }

  microsoft_defender {
    log_analytics_workspace_id = var.azurerm_log_analytics_workspace_id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
}