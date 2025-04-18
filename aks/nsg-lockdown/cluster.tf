resource "azurerm_kubernetes_cluster" "this" {
  depends_on = [
    azurerm_user_assigned_identity.aks_identity,
    azurerm_user_assigned_identity.aks_kubelet_identity,
    azurerm_log_analytics_workspace.this,
    azurerm_subnet.api,
    azurerm_subnet.nodes,
    azurerm_role_assignment.aks_role_assignemnt_network,
    azurerm_role_assignment.aks_role_assignemnt_msi,
    azurerm_subnet_route_table_association.nodes,
    azurerm_firewall.this,
  ]

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
      kubernetes_version
    ]
  }

  name                         = local.aks_name
  resource_group_name          = azurerm_resource_group.this["aks"].name
  location                     = azurerm_resource_group.this["aks"].location
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
  node_os_upgrade_channel      = "SecurityPatch"
  automatic_upgrade_channel    = "patch"

  # api_server_access_profile {
  #   vnet_integration_enabled = true
  #   subnet_id                = azurerm_subnet.api.id
  # }

  # key_management_service {
  #   key_vault_key_id         = azurerm_key_vault_key.etcd_encryption_key.id
  #   key_vault_network_access = "Private"
  # }

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
    name                 = "system"
    node_count           = var.node_count
    vm_size              = var.vm_size
    zones                = local.aks_zones
    os_disk_size_gb      = 127
    vnet_subnet_id       = azurerm_subnet.nodes.id
    os_sku               = var.vm_os
    type                 = "VirtualMachineScaleSets"
    auto_scaling_enabled = true
    min_count            = var.node_count
    max_count            = (var.node_count + 2)
    max_pods             = 250

    upgrade_settings {
      max_surge = "25%"
    }
  }

  service_mesh_profile {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = true
    revisions                        = [local.istio_version]
  }

  network_profile {
    dns_service_ip      = local.dns_service_ip
    service_cidr        = local.services_cidr
    pod_cidr            = local.pod_cidr
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
    outbound_type       = "userDefinedRouting"
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
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  monitor_metrics {
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
}

