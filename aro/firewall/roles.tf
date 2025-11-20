
resource "azurerm_role_assignment" "ccm_master_subnet" {
  scope                = azurerm_subnet.master_subnet.id
  role_definition_name = "Azure Red Hat OpenShift Cloud Controller Manager"
  principal_id         = azurerm_user_assigned_identity.cloud_controller_manager.principal_id
}

resource "azurerm_role_assignment" "ccm_worker_subnet" {
  scope                = azurerm_subnet.worker_subnet.id
  role_definition_name = "Azure Red Hat OpenShift Cloud Controller Manager"
  principal_id         = azurerm_user_assigned_identity.cloud_controller_manager.principal_id
}

resource "azurerm_role_assignment" "ccm_nsg" {
  scope                = azurerm_network_security_group.this.id
  role_definition_name = "Azure Red Hat OpenShift Cloud Controller Manager"
  principal_id         = azurerm_user_assigned_identity.cloud_controller_manager.principal_id
}

resource "azurerm_role_assignment" "ingress_master_subnet" {
  scope                = azurerm_subnet.master_subnet.id
  role_definition_name = "Azure Red Hat OpenShift Cluster Ingress Operator"
  principal_id         = azurerm_user_assigned_identity.ingress.principal_id
}

resource "azurerm_role_assignment" "ingress_worker_subnet" {
  scope                = azurerm_subnet.worker_subnet.id
  role_definition_name = "Azure Red Hat OpenShift Cluster Ingress Operator"
  principal_id         = azurerm_user_assigned_identity.ingress.principal_id
}

resource "azurerm_role_assignment" "machine_api_master_subnet" {
  scope                = azurerm_subnet.master_subnet.id
  role_definition_name = "Azure Red Hat OpenShift Machine API Operator"
  principal_id         = azurerm_user_assigned_identity.machine_api.principal_id
}

resource "azurerm_role_assignment" "machine_api_worker_subnet" {
  scope                = azurerm_subnet.worker_subnet.id
  role_definition_name = "Azure Red Hat OpenShift Machine API Operator"
  principal_id         = azurerm_user_assigned_identity.machine_api.principal_id
}

resource "azurerm_role_assignment" "machine_api_nsg" {
  scope                = azurerm_network_security_group.this.id
  role_definition_name = "Azure Red Hat OpenShift Machine API Operator"
  principal_id         = azurerm_user_assigned_identity.machine_api.principal_id
}


resource "azurerm_role_assignment" "cloud_network_vnet" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Azure Red Hat OpenShift Network Operator"
  principal_id         = azurerm_user_assigned_identity.cloud_network_config.principal_id
}

resource "azurerm_role_assignment" "cloud_network_nsg" {
  scope                = azurerm_network_security_group.this.id
  role_definition_name = "Azure Red Hat OpenShift Network Operator"
  principal_id         = azurerm_user_assigned_identity.cloud_network_config.principal_id
}

resource "azurerm_role_assignment" "file_csi_vnet" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Azure Red Hat OpenShift File Storage Operator"
  principal_id         = azurerm_user_assigned_identity.file_csi_driver.principal_id
}

resource "azurerm_role_assignment" "file_network_nsg" {
  scope                = azurerm_network_security_group.this.id
  role_definition_name = "Azure Red Hat OpenShift File Storage Operator"
  principal_id         = azurerm_user_assigned_identity.file_csi_driver.principal_id
}

resource "azurerm_role_assignment" "image_registry_vnet" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Azure Red Hat OpenShift Image Registry Operator"
  principal_id         = azurerm_user_assigned_identity.image_registry.principal_id
}

resource "azurerm_role_assignment" "aro_operator_master_subnet" {
  scope                = azurerm_subnet.master_subnet.id
  role_definition_name = "Azure Red Hat OpenShift Service Operator"
  principal_id         = azurerm_user_assigned_identity.operator.principal_id
}

resource "azurerm_role_assignment" "aro_operator_worker_subnet" {
  scope                = azurerm_subnet.worker_subnet.id
  role_definition_name = "Azure Red Hat OpenShift Service Operator"
  principal_id         = azurerm_user_assigned_identity.operator.principal_id
}

resource "azurerm_role_assignment" "aro_operator_nsg" {
  scope                = azurerm_network_security_group.this.id
  role_definition_name = "Azure Red Hat OpenShift Service Operator"
  principal_id         = azurerm_user_assigned_identity.operator.principal_id
}

resource "azurerm_role_assignment" "aro_rp_vnet" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.aro_resource_provider.object_id
}

resource "azurerm_role_assignment" "aro_rp_nsg" {
  scope                = azurerm_network_security_group.this.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.aro_resource_provider.object_id
}

resource "azurerm_role_assignment" "cluster_to_cloud_controller" {
  scope                = azurerm_user_assigned_identity.cloud_controller_manager.id
  role_definition_name = "Azure Red Hat OpenShift Federated Credential"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

resource "azurerm_role_assignment" "cluster_to_cloud_network" {
  scope                = azurerm_user_assigned_identity.cloud_network_config.id
  role_definition_name = "Azure Red Hat OpenShift Federated Credential"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

resource "azurerm_role_assignment" "cluster_to_disk_csi" {
  scope                = azurerm_user_assigned_identity.disk_csi_driver.id
  role_definition_name = "Azure Red Hat OpenShift Federated Credential"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

resource "azurerm_role_assignment" "cluster_to_ingress" {
  scope                = azurerm_user_assigned_identity.ingress.id
  role_definition_name = "Azure Red Hat OpenShift Federated Credential"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

resource "azurerm_role_assignment" "cluster_to_image_registry" {
  scope                = azurerm_user_assigned_identity.image_registry.id
  role_definition_name = "Azure Red Hat OpenShift Federated Credential"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

resource "azurerm_role_assignment" "cluster_to_file_csi" {
  scope                = azurerm_user_assigned_identity.file_csi_driver.id
  role_definition_name = "Azure Red Hat OpenShift Federated Credential"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

resource "azurerm_role_assignment" "cluster_to_aro_operator" {
  scope                = azurerm_user_assigned_identity.operator.id
  role_definition_name = "Azure Red Hat OpenShift Federated Credential"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

resource "azurerm_role_assignment" "cluster_to_machine_api" {
  scope                = azurerm_user_assigned_identity.machine_api.id
  role_definition_name = "Azure Red Hat OpenShift Federated Credential"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}
