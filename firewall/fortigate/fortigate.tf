# firewall.tf
# deploy fortigate VMs and Azure Standard Load Balancers
#
resource "azurerm_availability_set" "fw" {
	name                            = format("%s-avset-fw", var.prefix)
  location                        = var.location
  resource_group_name             = var.rg
  
  platform_update_domain_count    = 20 
  platform_fault_domain_count     = 2
  
  managed                         = true # aligned
}

resource "azurerm_network_interface" "nic1" {
	count                               = var.vm_num

	name                                = format("%s-firewall%02d-nic1", var.prefix, count.index + 1)
  location                            = var.location
  resource_group_name                 = var.rg

  ip_configuration {
    name                              = "ipconfig0"
    subnet_id                         = var.external_subnet_id
    private_ip_address_allocation     = "static"
	  private_ip_address                = cidrhost("${var.external_subnet_prefix}", var.ext_nic_ip_offset + count.index) 
  }

  enable_ip_forwarding = "true" # added for temporary 
  
  enable_accelerated_networking       = "false" # "true" /* for temporary */
}

resource "azurerm_network_interface" "nic2" {
	count                               = var.vm_num
	
	name                                = format("%s-firewall%02d-nic2", var.prefix, count.index + 1)
  location                            = var.location
  resource_group_name                 = var.rg
  
  ip_configuration {
    name                              = "ipconfig0"
    subnet_id                         = var.internal_subnet_id
    private_ip_address_allocation = "static"
	  private_ip_address                = cidrhost("${var.internal_subnet_prefix}", var.int_nic_ip_offset + count.index) 
  }

  enable_ip_forwarding = "true"
  enable_accelerated_networking       = "false" # "true" /* for temporary */
}

resource "azurerm_virtual_machine" "fw" {
	count                               = var.vm_num
  
  name                                = format("%s-firewall%02d", var.prefix, count.index + 1)
  location                            = var.location
  resource_group_name                 = var.rg

  vm_size                             = var.vm_size


  storage_os_disk {
		name                              = format("%s-firewall%02d-osdisk", var.prefix, count.index + 1)
    caching                           = "ReadWrite"
    create_option                     = "FromImage"
    managed_disk_type                 = "Premium_LRS"
  } 

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference { 
    publisher = "fortinet" 
    offer     = "fortinet_fortigate-vm_v5"
    sku       = "fortinet_fg-vm"
    version   = "6.2.3"
  }

  # plan information required for marketplace images
  plan {
    name      = "fortinet_fg-vm"
    product   = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
  }
 
  storage_data_disk {
		name                              = format("%s-firewall%02d-datadisk", var.prefix, count.index + 1)
    managed_disk_type                 = "Premium_LRS"
    create_option                     = "Empty"
    lun                               = 0
    disk_size_gb                      = "30"
  }
    
  os_profile {
		computer_name   = format("%s-fw%02d", var.prefix, count.index + 1)
    admin_username  = var.admin_username
    admin_password  = var.admin_password
    custom_data     = filebase64(format("customdata-%02d.txt", count.index + 1)) # blocked temporary for debugging
  }

  availability_set_id = azurerm_availability_set.fw.id

  os_profile_linux_config {
    disable_password_authentication = false
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_endpoint == null ? [] : ["BootDiagnostics"]
    content {
		  enabled               = var.boot_diagnostics_endpoint != null ? true : false
		  storage_uri           = var.boot_diagnostics_endpoint
    }
	}

	network_interface_ids = [element(azurerm_network_interface.nic1.*.id, count.index), element(azurerm_network_interface.nic2.*.id, count.index)]
  primary_network_interface_id = element(azurerm_network_interface.nic1.*.id, count.index)

}

resource "azurerm_network_interface_backend_address_pool_association" "extlb" {
	count = var.vm_num

	network_interface_id    = element(azurerm_network_interface.nic1.*.id, count.index)
	ip_configuration_name = "ipconfig0"

	backend_address_pool_id = var.extlb_backend_address_pool_id
}

resource "azurerm_network_interface_backend_address_pool_association" "extlb_outbound" {
	count = var.vm_num

	network_interface_id    = element(azurerm_network_interface.nic1.*.id, count.index)
	ip_configuration_name = "ipconfig0"

	backend_address_pool_id = var.extlb_backend_outbound_address_pool_id
}

resource "azurerm_network_interface_backend_address_pool_association" "intlb" {
	count = var.vm_num

  network_interface_id    = element(azurerm_network_interface.nic2.*.id, count.index)
	ip_configuration_name = "ipconfig0"
	backend_address_pool_id = var.intlb_backend_address_pool_id
}

/*
resource "azurerm_network_interface_nat_rule_association" "test" {
	count = "${var.vmnum}"

	network_interface_id    = "${element(azurerm_network_interface.nic1.*.id, count.index)}"
	ip_configuration_name = "${join("", list("ipconfig", "0"))}"

	nat_rule_id = "${azurerm_lb_nat_rule.rule1.*.id[count.index]}"
}
*/

