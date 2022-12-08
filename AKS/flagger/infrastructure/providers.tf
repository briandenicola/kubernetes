terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.33.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "0.1.1"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}
