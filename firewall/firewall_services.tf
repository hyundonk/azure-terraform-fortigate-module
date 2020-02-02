module "public_ip_address" {
  source                            = "../modules/pip/"

  prefix                            = local.prefix
  services                          = var.services
  
  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_firewall"]

  public_ip_prefix_id               = local.public_ip_prefix.id
  tags                              = local.tags
  
  diagnostics_settings              = var.ip_addr_diags
  diagnostics_map                   = local.diagnostics_map
  log_analytics_workspace_id        = local.log_analytics_workspace.id
}

module "public_ip_address_outbound" {
  source                            = "../modules/pip/"

  prefix                            = local.prefix
  services                          = var.services_outbound

  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_firewall"]

  public_ip_prefix_id               = local.public_ip_prefix.id
  tags                              = local.tags
  
  diagnostics_settings              = var.ip_addr_diags
  diagnostics_map                   = local.diagnostics_map
  log_analytics_workspace_id        = local.log_analytics_workspace.id
}

module "external_load_balancer" {
  source                            = "./ext-lb/"

  frontend_ip_addresses             = module.public_ip_address.public_ip
  frontend_ip_address_outbound      = module.public_ip_address_outbound.public_ip

  prefix                            = local.prefix
  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_firewall"]
  tags                              = local.tags
}

module "internal_load_balancer" {
  source                            = "./int-lb/"

	frontend_ip_addresses             = var.int_lb_frontend_ip
	#frontend_ip_addresses             = [cidrhost(local.subnet_prefix_map["service-fwint"], var.int_lb_frontend_ip_offset)]

  subnet_id                         = local.subnet_ids_map["service-fwint"]

  prefix                            = local.prefix
  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_firewall"]
  tags                              = local.tags
}

module "route_table_to_internal_lb" {
  source                            = "git://github.com/hyundonk/aztf-module-rt.git"

  name                              = "${local.prefix}-rt-to-internal-lb"
  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_firewall"]

  routes                            = var.route_internet_out

  #address_prefix                    = "0.0.0.0/0" # Route to Internet
  #next_hop_type                     = "VirtualAppliance"
	#next_hop_in_ip_address            = cidrhost(local.subnet_prefix_map["service-fwint"], var.int_lb_frontend_ip_offset)

  tags                              = local.tags
}

module "fortigate" {
  source                            = "./fortigate/"
  
  prefix                            = local.prefix
  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_firewall"]
  tags                              = local.tags

  vm_num                            = var.vm_num_fortigate
  vm_size                           = var.vm_size_fortigate

  external_subnet_id                = local.subnet_ids_map["service-fwext"]
  external_subnet_prefix            = local.subnet_prefix_map["service-fwext"]
  
  internal_subnet_id                = local.subnet_ids_map["service-fwint"]
  internal_subnet_prefix            = local.subnet_prefix_map["service-fwint"]

  ext_nic_ip_offset                 = var.ext_nic_ip_offset
  int_nic_ip_offset                 = var.int_nic_ip_offset

  admin_username                    = local.admin_username
  admin_password                    = local.admin_password
  
  extlb_backend_address_pool_id             = module.external_load_balancer.backend_address_pool_id
  extlb_backend_outbound_address_pool_id    = module.external_load_balancer.backend_outbound_address_pool_id

  # use internal load balancer in external subnet for temporary to test fortitester
  intlb_backend_address_pool_id             = module.internal_lb_for_fortitester.backend_address_pool_id
  #intlb_backend_address_pool_id             = module.internal_load_balancer.backend_address_pool_id
  
  boot_diagnostics_endpoint         = local.diagnostics_map.diags_sa_blob
}

module "fortimanager" {
  source                            = "./fortimanager/"
  
  prefix                            = local.prefix
  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_firewall"]
  tags                              = local.tags

  vm_size                           = var.vm_size_fortimanager

  subnet_id                         = local.subnet_ids_map["service-management"]

  private_ip_address                = cidrhost(local.subnet_prefix_map["service-management"], var.ip_offset_fortimanager)

  admin_username                    = local.admin_username
  admin_password                    = local.admin_password
  
  boot_diagnostics_endpoint         = local.diagnostics_map.diags_sa_blob
  recovery_vault_name               = local.recovery_vault_name
}

/*
module "fortianalyzer" {
  source                            = "./fortianalyzer/"
  
  prefix                            = local.prefix
  location                          = local.location_map["region1"]
  rg                                = local.resource_group_hub_names["resourcegroup_name_firewall"]
  tags                              = local.tags

  vm_size                           = var.vm_size_fortianalyzer

  subnet_id                         = local.subnet_ids_map["service-management"]

  private_ip_address                = cidrhost(local.subnet_prefix_map["service-management"], var.ip_offset_fortianalyzer)

  admin_username                    = local.admin_username
  admin_password                    = local.admin_password
}
*/
