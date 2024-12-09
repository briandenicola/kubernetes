locals {
  resource_groups = {
    aks = {
      name       = "${local.resource_name}_aks_rg"
      components = "Azure Kubernetes Service; Key Vault; Managed Identities; Zone - ${local.zone == null ? "none" : tostring(random_integer.zone.result)}"
    }
    network = {
      name       = "${local.resource_name}_network_rg"
      components = "Virtual Network; NSG; Azure Bastion; Azure Nat Gateway; Private DNS Zone; Private Endpoints"
    }
    monitor = {
      name       = "${local.resource_name}_monitor_rg"
      components = "Azure Monitor; Azure Log Analytics; Application Insights"
    }
    vm = {
      name       = "${local.resource_name}_vm_rg"
      components = "Azure Linux Virtual Machine (Zone - ${local.jump_vm_zone == null ? "none" : tostring(local.jump_vm_zone)})"
    }
  }
}

resource "azurerm_resource_group" "this" {
  for_each = local.resource_groups
  name     = each.value.name
  location = local.location

  tags = {
    Application = var.tags
    Components  = each.value.components
    Environment = local.sdlc_environment
    DeployedOn  = timestamp()
  }
}