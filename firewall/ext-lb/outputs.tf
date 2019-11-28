
output "backend_address_pool_id" {
	value = "${azurerm_lb_backend_address_pool.extlb.id}"
}

output "backend_outbound_address_pool_id" {
	value = "${azurerm_lb_backend_address_pool.extlb-outbound.id}"
}

