data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

resource "azurerm_kubernetes_cluster" "this" {
  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
    ]
  }

  name                            = local.aks_name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  node_resource_group             = "${local.resource_name}_k8s_nodes_rg"
  dns_prefix                      = local.aks_name
  sku_tier                        = "Paid"
  automatic_channel_upgrade       = "patch"
  oidc_issuer_enabled             = true
  workload_identity_enabled       = true
  azure_policy_enabled            = true
  local_account_disabled          = true 
  open_service_mesh_enabled       = false
  run_command_enabled             = false
  kubernetes_version              = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions)-2]
  api_server_authorized_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  image_cleaner_enabled           = true
  image_cleaner_interval_hours    = 48

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
    name                = "default"
    node_count          = 3
    vm_size             = "Standard_DS2_v2"
    os_disk_size_gb     = 30
    vnet_subnet_id      = azurerm_subnet.nodes.id
    pod_subnet_id       = azurerm_subnet.pods.id
    os_sku              = "CBLMariner"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 10
    max_pods            = 40
    upgrade_settings {
      max_surge         = "25%"
    }  
  }

  network_profile {
    dns_service_ip     = "100.${random_integer.services_cidr.id}.0.10"
    service_cidr       = "100.${random_integer.services_cidr.id}.0.0/16"
    docker_bridge_cidr = "172.17.0.1/16"
    network_plugin     = "azure"
    network_policy     = "calico"
    load_balancer_sku  = "standard"
  }

  maintenance_window {
    allowed {
      day               = "Friday"
      hours             = [21, 22, 22] 
    }
    allowed {
      day               = "Sunday"
      hours             = [1, 2, 3, 4, 5] 
    }
  }

  auto_scaler_profile {
    max_unready_nodes   = "1"
  }
  
  storage_profile {
    blob_driver_enabled = true
    disk_driver_enabled = true
    disk_driver_version = "v2"
    file_driver_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

}

data "azurerm_public_ip" "aks" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.this.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
}
