data "azurerm_client_config" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length = 1
  separator  = ""
}

locals {
    location                                = "southcentralus"
    resource_name                           = "${random_pet.this.id}-${random_id.this.dec}"
    aks_name                                = "${local.resource_name}-aks"
    azure_rbac_group_object_id              = ""
    github_actions_identity_name            = "gha-identity"
    github_actions_identity_resource_group  = "Core_Infra_DevOps_RG"
    core_subscription                       = ""
}

resource "azurerm_resource_group" "this" {
  name                  = "${local.resource_name}_rg"
  location              = local.location
  
  tags     = {
    Application = "helm-kubelogin"
    Components  = "aks; helm; demo"
    DeployedOn  = timestamp()
  }
}
