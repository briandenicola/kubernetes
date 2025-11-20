resource "azurerm_public_ip" "firewall" {
  name                = "${local.fw_name}-pip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "this" {
  name                = local.fw_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  firewall_policy_id  = azurerm_firewall_policy.this.id
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"

  ip_configuration {
    name                 = "confiugration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_firewall_policy" "this" {
  name                = "${local.fw_name}-rules"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  dns {
    proxy_enabled     = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "${local.fw_name}-rules-collections"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 500

  application_rule_collection {
    name     = "default_rules_collection"
    priority = 500
    action   = "Allow"
    rule {
      name = "azure-management"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = [
        "*"
      ]
      destination_fqdns = [
        "management.microsoft.com",
        "login.microsoftonline.com"
      ]
    }

    rule {
      name = "redhat-openshift"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = [
        "*"
      ]
      destination_fqdns = [
        "registry.redhat.io",
        "quay.io",
        "cdn.quay.io",
        "cdn01.quay.io",
        "cdn02.quay.io",
        "cdn03.quay.io",
        "cdn04.quay.io",
        "cdn05.quay.io",
        "cdn06.quay.io",
        "access.redhat.com",
        "registry.access.redhat.com",
        "registry.connect.redhat.com",
        "api.openshift.com",
        "mirror.openshift.com"
      ]
    }

  }
}
