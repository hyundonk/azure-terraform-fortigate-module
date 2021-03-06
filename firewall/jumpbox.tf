module "jumpbox_public_ip" {
  source                            = "../modules/pip/"

  prefix                            = local.prefix
  services                          = var.jumpbox_service
  
  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_management"]

  public_ip_prefix_id               = local.public_ip_prefix.id
  tags                              = local.tags
  
  diagnostics_settings              = var.ip_addr_diags
  diagnostics_map                   = local.diagnostics_map
  log_analytics_workspace_id        = local.log_analytics_workspace.id
}

module "jumpbox_vm" {
  source                            = "git://github.com/hyundonk/aztf-module-vm.git"

  prefix                            = var.prefix

  vm_num                            = 1
  vm_name                           = "jumpbox"
  vm_size                           = "Standard_D2s_v3"

  vm_publisher                      = "Canonical"
  vm_offer                          = "UbuntuServer"
  vm_sku                            = "16.04.0-LTS"
  vm_version                        = "latest"

  location                          = local.location_map["region1"]
  resource_group_name               = local.resource_group_hub_names["resourcegroup_name_management"]

  subnet_id                         = local.subnet_ids_map["service-management"]
  subnet_prefix                     = local.subnet_prefix_map["service-management"]
  subnet_ip_offset                  = 12

  admin_username                    = local.admin_username
  admin_password                    = local.admin_password

  boot_diagnostics_endpoint         = local.diagnostics_map.diags_sa_blob

  diag_storage_account_name         = null
  diag_storage_account_access_key   = null

  log_analytics_workspace_id        = null
  log_analytics_workspace_key       = null

  enable_network_watcher_extension  = false
  enable_dependency_agent           = false

  public_ip_id                      = module.jumpbox_public_ip.public_ip.0.id
}

module "syslog_vm" {
  source                            = "git://github.com/hyundonk/aztf-module-vm.git"

  prefix                            = var.prefix

  vm_num                            = 1
  vm_name                           = "syslog"
  vm_size                           = "Standard_D2s_v3"

  vm_publisher                      = "Canonical"
  vm_offer                          = "UbuntuServer"
  vm_sku                            = "16.04.0-LTS"
  vm_version                        = "latest"

  location                          = local.location_map["region1"]
  resource_group_name               = local.resource_group_hub_names["resourcegroup_name_management"]

  subnet_id                         = local.subnet_ids_map["service-management"]
  subnet_prefix                     = local.subnet_prefix_map["service-management"]
  subnet_ip_offset                  = 13

  admin_username                    = local.admin_username
  admin_password                    = local.admin_password

  boot_diagnostics_endpoint         = local.diagnostics_map.diags_sa_blob

  diag_storage_account_name         = null
  diag_storage_account_access_key   = null

  log_analytics_workspace_id        = null
  log_analytics_workspace_key       = null

  enable_network_watcher_extension  = false
  enable_dependency_agent           = false

  public_ip_id                      = null
}

