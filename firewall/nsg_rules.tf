
module "nsg_rules" {
  source = "./nsg_rules"

  nsg_rules_table         = var.nsg_rules_table

  rg                      = local.resource_group_hub_names["resourcegroup_name_network"]
  location                = local.location_map["region1"]
  tags                    = local.tags
}



