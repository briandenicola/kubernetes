resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location                  = var.region
  resource_name             = "${random_pet.this.id}-${random_id.this.dec}"
  acr_name                  = "${replace(local.resource_name, "-", "")}acr"
  storage_account_name      = "${replace(local.resource_name, "-", "")}sa"
  aml_workspace_name        = "${local.resource_name}-amlworkspace"
  virtual_network_name      = "${local.resource_name}-network"
  key_vault_name            = "${local.resource_name}-kv"
  application_insights_name = "${local.resource_name}-appinsights"
  ip_address                = chomp(data.http.myip.response_body)
}
