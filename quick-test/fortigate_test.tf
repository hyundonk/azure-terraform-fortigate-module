
resource "azurerm_resource_group" "rg" {
	name 				= "fortigatetest_rg"
	location    = "koreacentral"
}

resource "random_string" "prefix" {
    length  = 4
    special = false
    upper   = false
    number  = false
}

resource "azurerm_storage_account" "log" {
  name                      = "${random_string.prefix.result}fortiteststg"
	location 			            = azurerm_resource_group.rg.location
	resource_group_name		    = azurerm_resource_group.rg.name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  tags = {
    stgtfstate  = "fortitest"
  }

}

resource "azurerm_virtual_network" "vnet" {

	name                = "myvnet"
	location 			        = azurerm_resource_group.rg.location
	resource_group_name		= azurerm_resource_group.rg.name
	address_space         = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "ext" {
	name                    	= "external"
	resource_group_name		    = azurerm_resource_group.rg.name
	virtual_network_name    	= azurerm_virtual_network.vnet.name
	address_prefix          	= "10.20.0.0/24"
}

resource "azurerm_subnet" "int" {
	name                    	= "internal"
	resource_group_name		    = azurerm_resource_group.rg.name
	virtual_network_name    	= azurerm_virtual_network.vnet.name
	address_prefix          	= "10.20.1.0/24"
}

resource "azurerm_public_ip" "pip" {
	name                  = "fortigate-pip"
	location 			        = azurerm_resource_group.rg.location
	resource_group_name		= azurerm_resource_group.rg.name

	allocation_method     = "Static"
  sku                   = "Standard" # Standard Load Balancer requires Standard public IP
}


module "fortigate" {
  source                            = "./fortigate/"
  
  prefix                            = "ftgt"
	location 			                    = azurerm_resource_group.rg.location
	rg                                = azurerm_resource_group.rg.name
  tags                              = null

  vm_num                            = var.vm_num_fortigate
  vm_size                           = var.vm_size_fortigate

  external_subnet_id                = azurerm_subnet.ext.id
  external_subnet_prefix            = azurerm_subnet.ext.address_prefix
  
  internal_subnet_id                = azurerm_subnet.int.id
  internal_subnet_prefix            = azurerm_subnet.int.address_prefix

  ext_nic_ip_offset                 = 4
  int_nic_ip_offset                 = 4

  admin_username                    = "azureuser"
  admin_password                    = "Passw0rd!123"
  
  extlb_backend_address_pool_id             = null
  extlb_backend_outbound_address_pool_id    = null

  intlb_backend_address_pool_id             = null
   
  boot_diagnostics_endpoint         = azurerm_storage_account.log.primary_blob_endpoint

  public_ip_id                      = azurerm_public_ip.pip.id
}


