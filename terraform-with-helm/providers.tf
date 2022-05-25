terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm  = {
      source = "hashicorp/azurerm"
      version = "3.3.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

provider "azurerm" {
  features  {}
}

provider "azurerm" {
  features  {}
  alias           = "core"
  subscription_id = local.core_subscription
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.this.kube_config.0.host
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = [
        "get-token", 
        "--server-id", 
        "6dae42f8-4368-4678-94ff-3960e28e3630", 
        "--login", 
        "msi",
     ]
      command     = "kubelogin"
    }
  }
}