
resource "azurerm_public_ip" "public_ip" {
  for_each              = var.services

	name                  = "${var.prefix}-pip-${each.value.name}"
  location              = var.location
  resource_group_name   = var.rg

	allocation_method     = "Static"
	
  sku                   = "Standard" # Standard Load Balancer requires Standard public IP

	public_ip_prefix_id   = var.public_ip_prefix_id
  
  tags                  = var.tags
}


/*
output "public_ip" {
	value = {
		for ip in azurerm_public_ip.public_ip:
		ip.name => ip.id 
	}
}
*/
