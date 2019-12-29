module "vm" {
  source                            = "git://github.com/hyundonk/aztf-module-vm.git"

  prefix                            = var.prefix

  vm_num                            = var.service.vm_num
  vm_name                           = var.service.name
  vm_size                           = var.service.vm_size

  vm_publisher                      = var.service.vm_publisher
  vm_offer                          = var.service.vm_offer
  vm_sku                            = var.service.vm_sku
  vm_version                        = var.service.vm_version

  location                          = var.location
  resource_group_name               = var.rg

  subnet_id                         = var.subnet_ids_map[var.service.subnet]
  subnet_prefix                     = var.subnet_prefix_map[var.service.subnet]
  subnet_ip_offset                  = var.service.subnet_ip_offset

  admin_username                    = var.admin_username
  admin_password                    = var.admin_password

  boot_diagnostics_endpoint         = var.boot_diagnostics_endpoint

  diag_storage_account_name         = var.diag_storage_account_name
  diag_storage_account_access_key   = var.diag_storage_account_access_key

  log_analytics_workspace_id        = var.log_analytics_workspace_id
  log_analytics_workspace_key       = var.log_analytics_workspace_key

  enable_network_watcher_extension  = var.enable_network_watcher_extension
  enable_dependency_agent           = var.enable_dependency_agent

  load_balancer_param              = var.load_balancer_param
  custom_data                       = var.custom_data
}

resource "azurerm_subnet_route_table_association" "association" {
  count           = var.route_table_id == null ? 0 : 1 
  subnet_id       = var.subnet_ids_map[var.service.subnet]
  route_table_id  = var.route_table_id
}
