# Forti Manager

resource "azurerm_network_interface" "fortimanager" {
	name                                = format("%s-fortimanager-nic", var.prefix)
  location                            = var.location
  resource_group_name                 = var.rg

	ip_configuration {
    name                              = "ipconfig0"
    subnet_id                         = var.subnet_id
    private_ip_address_allocation     = "static"
	  private_ip_address                = var.private_ip_address
	}
}

resource "azurerm_virtual_machine" "fortimanager" {
	name                                = format("%s-fortimanager", var.prefix)
  location                            = var.location
  resource_group_name                 = var.rg
	vm_size                             = var.vm_size

	storage_image_reference {
		publisher = "fortinet"
		offer     = "fortinet-fortimanager"
		sku       = "fortinet-fortimanager"
		version   = "6.2.3"
	}

	plan {
        name      = "fortinet-fortimanager"
        product   = "fortinet-fortimanager"
        publisher = "fortinet"
  }
    
	storage_os_disk {
		name                  = format("%s-fortimanager-osdisk", var.prefix)
		caching               = "ReadWrite"
		create_option         = "FromImage"
		managed_disk_type     = "Premium_LRS"
	}

	storage_data_disk {
		name                  = format("%s-fortimanager-datadisk", var.prefix)
    managed_disk_type     = "Premium_LRS"
    create_option         = "Empty"
    lun                   = 0
    disk_size_gb          = "127"
  }

	os_profile {
		computer_name  = format("%s-fortimanager", var.prefix)
    admin_username = var.admin_username
    admin_password = var.admin_password
	}

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

	network_interface_ids = [azurerm_network_interface.fortimanager.id]
}
/* back up test code.
resource "azurerm_backup_protected_vm" "vm" {
  resource_group_name = "ebfg-backup"
  recovery_vault_name = var.recovery_vault_name

  source_vm_id        = azurerm_virtual_machine.fortimanager.id
  #backup_policy_id    = azurerm_backup_policy_vm.example.id
  backup_policy_id    = "/subscriptions/a9faab7f-03df-43e1-afa5-7ac794c596b6/resourceGroups/ebfg-backup/providers/Microsoft.RecoveryServices/vaults/ebfg-backup-asr-vault-cyg/backupPolicies/TFMamagedDefaultPolicyBackupRetention"
}
*/
