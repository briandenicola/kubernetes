data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

locals {
  zones              = var.region == "northcentralus" ? null : ["1", "2", "3"]
}

resource "azurerm_kubernetes_cluster" "this" {
  depends_on = [ 
    azurerm_role_assignment.aks_role_assignemnt_dns
  ]

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
      kubernetes_version
    ]
  }

  name                                = local.aks_name
  resource_group_name                 = azurerm_resource_group.this.name
  location                            = azurerm_resource_group.this.location
  node_resource_group                 = "${var.resource_name}_k8s_nodes_rg"
  dns_prefix_private_cluster          = local.aks_name
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  private_dns_zone_id                 = azurerm_private_dns_zone.aks_private_zone.id
  sku_tier                            = "Standard"
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  azure_policy_enabled                = true
  local_account_disabled              = false
  open_service_mesh_enabled           = false
  run_command_enabled                 = false
  kubernetes_version                  = var.kubernetes_version
  image_cleaner_enabled               = true
  image_cleaner_interval_hours        = 48

  automatic_channel_upgrade           = var.automatic_channel_upgrade
  node_os_channel_upgrade             = var.node_os_channel_upgrade

  api_server_access_profile {
    vnet_integration_enabled = true
    subnet_id                = azurerm_subnet.api.id
    //authorized_ip_ranges     = [var.authorized_ip_ranges]
  }

  azure_active_directory_role_based_access_control {
    managed            = true
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
    name                = "system"
    node_count          = 1
    vm_size             = var.vm_sku
    zones               = local.zones
    os_disk_size_gb     = 127
    vnet_subnet_id      = azurerm_subnet.nodes.id
    os_sku              = "Mariner"
    os_disk_type        = "Ephemeral"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 1
    max_pods            = 90
    upgrade_settings {
      max_surge = "25%"
    }
  }

  network_profile {
    dns_service_ip      = "100.${random_integer.services_cidr.id}.0.10"
    service_cidr        = "100.${random_integer.services_cidr.id}.0.0/16"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
    pod_cidr            = "100.${random_integer.pod_cidr.id}.0.0/16"
  }

  service_mesh_profile {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = true
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

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

}

