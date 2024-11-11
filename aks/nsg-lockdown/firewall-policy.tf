resource "azurerm_firewall_policy" "this" {
  name                = "${local.firewall_name}-policies"
  resource_group_name = azurerm_resource_group.this["network"].name
  location            = azurerm_resource_group.this["network"].location
  sku                 = "Standard"
  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "${local.firewall_name}_rules_collection"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 200

  application_rule_collection {
    name     = "app_rule_collection"
    priority = 500
    action   = "Allow"

    rule {
      name             = "Microsoft Containers Registry"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      destination_fqdns = [
        "mcr.microsoft.com",
        "*.data.mcr.microsoft.com",
        "packages.microsoft.com",
        "acs-mirror.azureedge.net"
      ]
    }

    rule {
      name             = "AKS Extensions"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      destination_fqdns = [
        "azure.github.io",
        "${local.location}.dp.kubernetesconfiguration.azure.com",
        "arcmktplaceprod.azurecr.io",
        "*.ingestion.msftcloudes.com",
        "*.microsoftmetrics.com",
        "marketplaceapi.microsoft.com",
        "arcmktplaceprod.westus2.data.azurecr.io",
        "arcmktplaceprod.westeurope.data.azurecr.io",
        "arcmktplaceprod.eastus.data.azurecr.io",
        "azure.github.io"
      ]
    }

    rule {
      name             = "Entra ID"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      destination_fqdns = [
        "management.microsoft.com",
        "login.microsoftonline.com",
        "*.identity.azure.net",
        "*.login.microsoftonline.com",
        "*.login.microsoft.com"
      ]
    }

    rule {
      name             = "Docker Hub"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      destination_fqdns = [
        "*.docker.io",
        "registry-1.docker.io",
        "production.cloudflare.docker.com"
      ]
    }

    rule {
      name             = "Ubuntu"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      protocols {
        type = "Http"
        port = 80
      }

      destination_fqdns = [
        "*.ubuntu.com"
      ]
    }

    rule {
      name             = "Github"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      destination_fqdns = [
        "*.github.com",
        "github.com",
        "raw.githubusercontent.com",
        "ghcr.io",
        "pkg-containers.githubusercontent.com",
        "objects.githubusercontent.com"
      ]
    }

    rule {
      name             = "Dapr"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      destination_fqdns = [
        "dapr.github.io",
        "linuxgeneva-microsoft.azurecr.io",
        "*.blob.core.windows.net"
      ]
    }

    rule {
      name             = "Azure Monitoring"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      destination_fqdns = [
        "dc.services.visualstudio.com",
        "${local.location}.handler.control.monitor.azure.com",
        "*.ingest.monitor.azure.com",
        "*.monitoring.azure.com",
        "*.ods.opinsights.azure.com",
        "*.oms.opinsights.azure.com"
      ]
    }


    rule {
      name             = "Azure Policy"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      destination_fqdns = [
        "data.policy.core.windows.net",
        "store.policy.core.windows.net"
      ]
    }

    rule {
      name             = "Miscellaneous"
      source_addresses = ["*"]

      protocols {
        port = "443"
        type = "Https"
      }

      protocols {
        port = "80"
        type = "Http"
      }

      destination_fqdns = [
        "aka.ms",
        "releases.hashicorp.com",
        "get.helm.sh",
        "ifconfig.me",
        "dl.k8s.io",
        "cdn.dl.k8s.io"
      ]
    }

  }

  network_rule_collection {
    name     = "network_rule_collection"
    priority = 400
    action   = "Allow"

    rule {
      name              = "monitor"
      source_addresses  = ["*"]
      destination_ports = ["443"]
      protocols         = ["TCP"]
      destination_addresses = [
        "AzureMonitor"
      ]
    }

    rule {
      name              = "keyvault"
      source_addresses  = ["*"]
      destination_ports = ["443"]
      protocols         = ["TCP"]
      destination_addresses = [
        "AzureKeyVault",
        "AzureActiveDirectory",
      ]
    }

    rule {
      name              = "managed_disks"
      source_addresses  = ["*"]
      destination_ports = ["443"]
      protocols         = ["TCP"]
      destination_addresses = [
        "AzureStorage"
      ]
    }
  }
}
