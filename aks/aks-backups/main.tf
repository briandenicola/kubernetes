resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location                   = var.region
  resource_name              = "${random_pet.this.id}-${random_id.this.dec}"
  authorized_ip_ranges       = "${chomp(data.http.myip.response_body)}/32"
  storage_account_name       = "${replace(local.resource_name, "-", "")}sa"
  data_protection_vault_name = "${local.resource_name}-dpv"
  container_name             = "backups"
  environment_type           = "dev"
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = var.region

  tags = {
    Application = var.tags
    Components  = "AKS Backup; Data Protection Vault"
    DeployedOn  = timestamp()
  }
}
