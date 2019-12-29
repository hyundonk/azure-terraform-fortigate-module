module "service1" {
  source                            = "./service"
  
  prefix                            = local.prefix
  service                          = var.services[0]

  subnet_ids_map                    = local.subnet_ids_map
  subnet_prefix_map                 = local.subnet_prefix_map

  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_services"]
  tags                              = local.tags

  admin_username                    = local.admin_username
  admin_password                    = local.admin_password

  boot_diagnostics_endpoint         = local.diagnostics_map.diags_sa_blob

  diag_storage_account_name         = null
  diag_storage_account_access_key   = null

  log_analytics_workspace_id        = null
  log_analytics_workspace_key       = null

  load_balancer_param              = var.load_balancer_param
#  route_table_id                    = module.route_table_to_internal_lb.id
  custom_data                       = var.custom_data
}

module "service2" {
  source                            = "./service"
  
  prefix                            = local.prefix
  service                          = var.services[1]

  subnet_ids_map                    = local.subnet_ids_map
  subnet_prefix_map                 = local.subnet_prefix_map

  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_services"]
  tags                              = local.tags

  admin_username                    = local.admin_username
  admin_password                    = local.admin_password

  boot_diagnostics_endpoint         = local.diagnostics_map.diags_sa_blob

  diag_storage_account_name         = null
  diag_storage_account_access_key   = null

  log_analytics_workspace_id        = null
  log_analytics_workspace_key       = null

  load_balancer_param              = var.load_balancer_param
#  route_table_id                    = module.route_table_to_internal_lb.id
  custom_data                       = var.custom_data
}


