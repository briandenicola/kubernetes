terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm  = {
      source = "hashicorp/azurerm"
      version = "3.69.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "1.1.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.29.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuread" {
}