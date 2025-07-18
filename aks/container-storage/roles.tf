
resource "azurerm_role_assignment" "container_storage_role" {
  depends_on = [
    data.azurerm_resource_group.aks_nodepool_rg
  ]
  scope                            = data.azurerm_resource_group.aks_nodepool_rg.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "cluster_admin_role" {
  count = var.deploy_jumpbox ? 1 : 0
  depends_on = [
    module.cluster,
    module.vm
  ]
  scope                            = module.cluster.AKS_CLUSTER_ID
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = module.vm[0].VM_PRINCIPAL_ID
}

resource "azurerm_role_assignment" "cluster_admin_creds" {
  count = var.deploy_jumpbox ? 1 : 0
  depends_on = [
    module.cluster,
    module.vm
  ]
  scope                            = module.cluster.AKS_CLUSTER_ID
  role_definition_name             = "Azure Kubernetes Service Cluster User Role"
  principal_id                     = module.vm[0].VM_PRINCIPAL_ID
}


resource "azurerm_role_assignment" "vm_rg_reader" {
  count = var.deploy_jumpbox ? 1 : 0
  depends_on = [
    module.cluster,
    module.vm
  ]
  scope                            = module.vm[0].VM_RESOURCE_GROUP_ID
  role_definition_name             = "Reader"
  principal_id                     = module.vm[0].VM_PRINCIPAL_ID
}
resource "azurerm_role_assignment" "aks_rg_reader" {
  count = var.deploy_jumpbox ? 1 : 0
  depends_on = [
    module.cluster,
    module.vm
  ]
  scope                            = data.azurerm_resource_group.aks_rg.id
  role_definition_name             = "Reader"
  principal_id                     = module.vm[0].VM_PRINCIPAL_ID
}