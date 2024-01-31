resource "azurerm_mssql_server" "this" {
  name                         = "${local.resource_name}-sql"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "manager"
  administrator_login_password = random_password.password.result
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = data.azurerm_client_config.current.object_id
  }

}

resource "azurerm_mssql_database" "this" {
  name                = "todo"
  server_id           = azurerm_mssql_server.this.id
}

resource "azurerm_mssql_firewall_rule" "home" {
  name             = "AllowHomeNetwork"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "${chomp(data.http.myip.response_body)}"
  end_ip_address   = "${chomp(data.http.myip.response_body)}"
}

resource "azurerm_mssql_firewall_rule" "aks" {
  name             = "AKS"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = var.aks_ip_address
  end_ip_address   = var.aks_ip_address
}

