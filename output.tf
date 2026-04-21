output "epicbook_public_ip" {
  value = azurerm_public_ip.epicbook_public_ip.ip_address
}

output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}
