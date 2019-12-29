
resource "azurerm_lb" "extlb" {
	name		              = "${format("%s-extlb", var.prefix)}"
  location              = var.location
  resource_group_name   = var.rg

  sku = "Standard"

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_addresses

    content {
      name                  = frontend_ip_configuration.value.name
      public_ip_address_id  = frontend_ip_configuration.value.id
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_address_outbound
    content {
      name                  = frontend_ip_configuration.value.name
      public_ip_address_id  = frontend_ip_configuration.value.id
    }
  }
}

resource "azurerm_lb_probe" "probe" {
    resource_group_name       = azurerm_lb.extlb.resource_group_name
    loadbalancer_id           = azurerm_lb.extlb.id
    name                      = "${azurerm_lb.extlb.name}-probe"
    protocol                  = "Http"
    port                      = 8008 
    request_path              ="/"

    interval_in_seconds       = 5
	  number_of_probes          = 2
}

resource "azurerm_lb_backend_address_pool" "extlb" {
  resource_group_name         = azurerm_lb.extlb.resource_group_name
  loadbalancer_id             = azurerm_lb.extlb.id
  name                        = "${azurerm_lb.extlb.name}-backendpool"
}

resource "azurerm_lb_backend_address_pool" "extlb-outbound" {
  resource_group_name         = azurerm_lb.extlb.resource_group_name
  loadbalancer_id             = azurerm_lb.extlb.id
  name                        = "${azurerm_lb.extlb.name}-backendpool-outbound"
}


# outbound rule. Use separate dedicated public IP address for outbound connection
resource "azurerm_lb_outbound_rule" "outbound" {
  resource_group_name         = azurerm_lb.extlb.resource_group_name
  loadbalancer_id             = azurerm_lb.extlb.id
	name                        = "outbound-rule"
	protocol                    = "Tcp"
	
  backend_address_pool_id     = azurerm_lb_backend_address_pool.extlb-outbound.id

	idle_timeout_in_minutes     = 4

	frontend_ip_configuration {
    name = var.frontend_ip_address_outbound[0].name
	}
}

/* 
resource "azurerm_lb_nat_rule" "rule1" {
	count                           = var.vmnum

  resource_group_name             = azurerm_lb.extlb.resource_group_name
  loadbalancer_id                 = azurerm_lb.extlb.id
  name                            = "fw1adminperm-${count.index}"
  protocol                        = "Tcp"
  frontend_port                   = "${8443 + count.index}" 
  backend_port                    = 9443
  frontend_ip_configuration_name  = "extlb-pip1"
}

resource "azurerm_lb_nat_rule" "rule2" {
    resource_group_name  =  "${azurerm_resource_group.resourcegroup.name}"
    loadbalancer_id     = "${azurerm_lb.extlb.id}"
    name                           = "fw2adminperm"
    protocol                       = "Tcp"
    frontend_port                  = 8443 
    backend_port                   = 8443
    frontend_ip_configuration_name = "extlb-pip2"
}
*/

resource "azurerm_lb_rule" "https" {
    for_each                        = var.frontend_ip_addresses

    resource_group_name             = azurerm_lb.extlb.resource_group_name
    loadbalancer_id                 = azurerm_lb.extlb.id
	  name		                        = "https-${each.value.name}"
    
    protocol                        = "Tcp"
    frontend_port                   = 443
    backend_port                    = 443

    frontend_ip_configuration_name  = each.value.name
    
	  backend_address_pool_id         = azurerm_lb_backend_address_pool.extlb.id
    probe_id                        = azurerm_lb_probe.probe.id
    depends_on                      = ["azurerm_lb_probe.probe"]

    enable_floating_ip              = true
	  idle_timeout_in_minutes         = 4
	  load_distribution               = "Default"

	  disable_outbound_snat           = true
}

resource "azurerm_lb_rule" "http" {
    for_each                        = var.frontend_ip_addresses
    
    resource_group_name             = azurerm_lb.extlb.resource_group_name
    loadbalancer_id                 = azurerm_lb.extlb.id
	  name		                        = "http-${each.value.name}"
 
    protocol                        = "Tcp"
    frontend_port                   = 80
    backend_port                    = 80
    
    frontend_ip_configuration_name  = each.value.name
    
    backend_address_pool_id         = azurerm_lb_backend_address_pool.extlb.id
    probe_id                        = azurerm_lb_probe.probe.id
    depends_on                      = ["azurerm_lb_probe.probe"]

    enable_floating_ip              = true
	  idle_timeout_in_minutes         = 4
	  load_distribution               = "Default"

	  disable_outbound_snat           = true
}

