resource "time_sleep" "wait_for_rbac" {
  depends_on = [
    azurerm_role_assignment.cluster_to_cloud_controller,
    azurerm_role_assignment.cluster_to_ingress,
    azurerm_role_assignment.cluster_to_machine_api,
    azurerm_role_assignment.cluster_to_disk_csi,
    azurerm_role_assignment.cluster_to_cloud_network,
    azurerm_role_assignment.cluster_to_image_registry,
    azurerm_role_assignment.cluster_to_file_csi,
    azurerm_role_assignment.cluster_to_aro_operator,
    azurerm_role_assignment.ccm_master_subnet,
    azurerm_role_assignment.ccm_worker_subnet,
    azurerm_role_assignment.ingress_master_subnet,
    azurerm_role_assignment.ingress_worker_subnet,
    azurerm_role_assignment.machine_api_master_subnet,
    azurerm_role_assignment.machine_api_worker_subnet,
    azurerm_role_assignment.cloud_network_vnet,
    azurerm_role_assignment.file_csi_vnet,
    azurerm_role_assignment.image_registry_vnet,
    azurerm_role_assignment.aro_operator_master_subnet,
    azurerm_role_assignment.aro_operator_worker_subnet,
    azurerm_role_assignment.aro_rp_vnet,
  ]

  create_duration = "30s"
}
