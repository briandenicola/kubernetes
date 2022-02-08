terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.89"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }
}

locals {
  namespace = "spn-test"
  tenant_id = "cf62007c-c1b2-44d4-82a8-f8bc84dca791"
  client_id = "9bb78c3c-247f-4e37-8518-606df03d66a9"
  cluster_name = "my_cluster"
  cluster_rg = "AKS_RG"
}

provider "azuread" {
  tenant_id = local.tenant_id
}

provider "azurerm" {
  features  {}
}

data "azuread_service_principal" "k8s" {
  application_id = local.client_id
}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = local.cluster_name
  resource_group_name = local.cluster_rg
}

resource "azurerm_role_assignment" "k8s_namespace" {
  scope                = "${data.azurerm_kubernetes_cluster.k8s.id}/namespaces/${local.namespace}"
  role_definition_name = "Azure Kubernetes Service RBAC Admin"
  principal_id         = data.azuread_service_principal.k8s.object_id
  skip_service_principal_aad_check = true
}