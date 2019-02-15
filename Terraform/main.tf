provider "azurerm" {
  version = "=1.5.0"
}

terraform {
  backend "azurerm" {
    storage_account_name = "tfstatestorage001"
    container_name       = "plans"
    key                  = "prod.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "k8s" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}


resource "azurerm_log_analytics_workspace" "k8s" {
    name                = "${var.log_analytics_workspace_name}"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.k8s.name}"
    sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "k8s" {
    solution_name         = "ContainerInsights"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.k8s.name}"
    workspace_resource_id = "${azurerm_log_analytics_workspace.k8s.id}"
    workspace_name        = "${azurerm_log_analytics_workspace.k8s.name}"

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "${var.cluster_name}"

  linux_profile {
    admin_username = "${var.admin_user}"

    ssh_key {
      key_data = "${var.ssh_public_key}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "${var.vm_size}"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  addon_profile {
      oms_agent {
        enabled                    = true
        log_analytics_workspace_id = "${azurerm_log_analytics_workspace.k8s.id}"
      }
  }

  tags {
    Environment = "Production"
  }
}