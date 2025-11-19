resource "azurerm_user_assigned_identity" "cluster" {
  name                = "${local.aro_name}-cluster-identity"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "cloud_controller_manager" {
  name                = "${local.aro_name}-cloud-controller-manager"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "ingress" {
  name                = "${local.aro_name}-ingress"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "machine_api" {
  name                = "${local.aro_name}-machine-api"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "disk_csi_driver" {
  name                = "${local.aro_name}-disk-csi-driver-identity"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "cloud_network_config" {
  name                = "${local.aro_name}-cloud-network-config"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "image_registry" {
  name                = "${local.aro_name}-registry-identity"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "file_csi_driver" {
  name                = "${local.aro_name}-file-csi-driver-identity"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "operator" {
  name                = "${local.aro_name}-operator-identity"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
