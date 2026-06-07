resource "azurerm_mssql_server" "server" {

  name                         = var.server_name
  resource_group_name         = var.resource_group_name
  location                     = var.location

  version                      = "12.0"
  administrator_login         = var.administrator_login
  administrator_login_password = var.administrator_password

  minimum_tls_version = "1.2"

  tags = {
    environment = var.environment
    managed_by  = "backstage-service-composer"
  }
}

resource "azurerm_mssql_database" "db" {

  name      = var.database_name
  server_id = azurerm_mssql_server.server.id

  sku_name = "Basic"

  tags = {
    environment = var.environment
    managed_by  = "backstage-service-composer"
  }
}
