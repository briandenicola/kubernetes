terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.0"
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

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.this.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630",
      "--client-id",
      "80faf920-1908-4b52-b5ef-a8e7bedfc67a",
      "--tenant-id",
      data.azurerm_client_config.current.tenant_id,
      "--login",
      "azurecli",
    ]
    command = "kubelogin"
  }
}
