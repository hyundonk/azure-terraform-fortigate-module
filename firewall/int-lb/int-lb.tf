# Internal Standard Load Balancer for distributing outbound connection to 3rd party firewall instances

resource "azurerm_lb" "intlb" {
	name		              = "${format("%s-intlb", var.prefix)}"
  location              = var.location
  resource_group_name   = var.rg

  sku = "Standard"
    
  frontend_ip_configuration {
    name                          = "intlb-frontend-ip"
    subnet_id                     = var.subnet_id
		private_ip_address            = var.frontend_ip_address
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_probe" "probe" {
    resource_group_name       = azurerm_lb.intlb.resource_group_name
    loadbalancer_id           = azurerm_lb.intlb.id
    name                      = "${azurerm_lb.intlb.name}-probe"
    protocol                  = "Http" # "Tcp"
    port                      = 8008 # 22
    request_path              ="/"

    interval_in_seconds       = 5
	  number_of_probes          = 2
}

resource "azurerm_lb_backend_address_pool" "intlb" {
    resource_group_name             = azurerm_lb.intlb.resource_group_name
    loadbalancer_id                 = azurerm_lb.intlb.id
    name                            = "backendpool"
}

# configure standard LB HA port rule. Note that HA port rule cannot be co-exist with NAT rule(s)
resource "azurerm_lb_rule" "ha" {
    resource_group_name             = azurerm_lb.intlb.resource_group_name
    loadbalancer_id                 = azurerm_lb.intlb.id
    name                            = "ha"
    protocol                        = "All"
    frontend_port                   = 0 
    backend_port                    = 0
    frontend_ip_configuration_name  = azurerm_lb.intlb.frontend_ip_configuration[0].name
    #frontend_ip_configuration_name  = "intlb-frontend-ip"
    backend_address_pool_id         = azurerm_lb_backend_address_pool.intlb.id
    probe_id                        = azurerm_lb_probe.probe.id
    depends_on                      = ["azurerm_lb_probe.probe"]
    
    enable_floating_ip = true
}

/*
resource "azurerm_network_interface_backend_address_pool_association" "intlb" {
	network_interface_id    = "${element(azurerm_network_interface.nic02.*.id, count.index)}"
	ip_configuration_name = "${join("", list("ipconfig", "1"))}"

	backend_address_pool_id = "${azurerm_lb_backend_address_pool.intlb.id}"

	count = "${var.vmnum}"
}
*/

