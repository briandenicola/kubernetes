terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }    
  }
}