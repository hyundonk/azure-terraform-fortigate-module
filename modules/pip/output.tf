output "public_ip" {
  value = azurerm_public_ip.public_ip
}

output "public_ip_diag" {
  value = azurerm_monitor_diagnostic_setting.diagnostics
}

/*
output "ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "fqdn" {
  value = azurerm_public_ip.public_ip.fqdn
}

output "name" {
  value = azurerm_public_ip.public_ip.name
}

output "id" {
  value = azurerm_public_ip.public_ip.id
}
*/

