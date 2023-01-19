resource "azurerm_kubernetes_cluster" "this" {
  name                      = "${local.aks_name}"
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  node_resource_group       = "${local.resource_name}_k8s_nodes_rg"
  dns_prefix                = "${local.aks_name}"
  sku_tier                  = "Paid"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  api_server_authorized_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]

  identity {
    type                    = "SystemAssigned"
  }

  default_node_pool  {
    name                    = "default"
    node_count              = 3
    vm_size                = "Standard_DS2_v2"
    os_disk_size_gb         = 30
    vnet_subnet_id          = azurerm_subnet.this.id
    type                    = "VirtualMachineScaleSets"
    enable_auto_scaling     = true
    min_count               = 3
    max_count               = 10
    max_pods                = 40
  }

  network_profile {
    dns_service_ip          = "100.${random_integer.services_cidr.id}.0.10"
    service_cidr            = "100.${random_integer.services_cidr.id}.0.0/16"
    docker_bridge_cidr      = "172.17.0.1/16"
    network_plugin          = "azure"
    load_balancer_sku       = "standard"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

}

data "azurerm_public_ip" "aks" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.this.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
}