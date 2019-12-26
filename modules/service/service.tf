module "lb" {
  source                            = "git://github.com/hyundonk/aztf-module-lb.git"

  name                              = "${var.prefix}-${var.name}"
  location                          = var.location
  rg                                = var.rg

  tags                              = var.tags
  sku                               = var.load_balancer_sku

  subnet_id                         = var.subnet_id
  subnet_prefix                     = var.subnet_prefix
  subnet_ip_offset                  = var.subnet_ip_offset

  protocol                          = var.load_balancer_probe_protocol
  port                              = var.load_balancer_probe_port
  interval                          = var.load_balancer_probe_interval
  number_of_probes                  = var.load_balancer_number_of_probes
}

module "vm" {
  source                            = "git://github.com/hyundonk/aztf-module-vm.git"

  prefix                            = var.prefix

  vm_num                            = 2
  vm_name                           = var.name
  vm_size                           = "Standard_D2s_v3"

  vm_publisher                      = "Canonical"
  vm_offer                          = "UbuntuServer"
  vm_sku                            = "16.04.0-LTS"
  vm_version                        = "latest"

  location                          = var.location
  resource_group_name               = var.rg

  subnet_id                         = var.subnet_id
  subnet_prefix                     = var.subnet_prefix
  subnet_ip_offset                  = var.subnet_ip_offset + 1

  admin_username                    = var.admin_username
  admin_password                    = var.admin_password

  boot_diagnostics_endpoint         = var.boot_diagnostics_endpoint

  diag_storage_account_name         = var.diag_storage_account_name
  diag_storage_account_access_key   = var.diag_storage_account_access_key

  log_analytics_workspace_id        = var.log_analytics_workspace_id
  log_analytics_workspace_key       = var.log_analytics_workspace_key

  enable_network_watcher_extension  = var.enable_network_watcher_extension
  enable_dependency_agent           = var.enable_dependency_agent

  lb_backend_address_pool_id        = module.lb.backend_address_pool_id

  dependencies = [
    module.lb.depended_on,
  ]
}

