locals {
  zones = var.region == "northcentralus" || var.region == "canadaeast" ? null : var.zones
}


resource "azurerm_kubernetes_cluster" "this" {
  depends_on = [
    azurerm_user_assigned_identity.aks_identity,
    azurerm_user_assigned_identity.aks_kubelet_identity,
    azurerm_role_assignment.aks_role_assignemnt_network,
    azurerm_role_assignment.aks_role_assignemnt_msi,
    azurerm_nat_gateway.this
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
  private_cluster_enabled      = true
  private_dns_zone_id          = azurerm_private_dns_zone.aks_private_zone.id
  dns_prefix_private_cluster   = local.aks_name
  sku_tier                     = "Standard"
  oidc_issuer_enabled          = true
  workload_identity_enabled    = true
  azure_policy_enabled         = true
  local_account_disabled       = false
  open_service_mesh_enabled    = false
  run_command_enabled          = false
  kubernetes_version           = local.kubernetes_version
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48
  automatic_upgrade_channel    = "patch"
  node_os_upgrade_channel      = "SecurityPatch"


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
      key_data = tls_private_key.rsa.public_key_openssh
    }
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet_identity.id
  }

  default_node_pool {
    name                = "system"
    node_count          = var.node_count
    vm_size             = var.vm_size
    zones               = local.zones
    os_disk_size_gb     = 127
    vnet_subnet_id      = azurerm_subnet.nodes.id
    os_sku              = var.vm_os
    type                = "VirtualMachineScaleSets"
    auto_scaling_enabled = true
    min_count           = 1
    max_count           = var.node_count
    max_pods            = 250

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
    outbound_type       = "userAssignedNATGateway"
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
    keda_enabled = true
    vertical_pod_autoscaler_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id      = var.log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = false
  }

  monitor_metrics {
  }

  microsoft_defender {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
}

