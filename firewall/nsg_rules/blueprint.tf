resource "azurerm_network_security_group" "nsg_obj" {
  for_each                = var.nsg_rules_table
  
  name                    = each.key

  resource_group_name     = var.rg
  location                = var.location
  tags                    = var.tags
  
  dynamic "security_rule" {
    for_each = concat(each.value.nsg_inbound, each.value.nsg_outbound)
    content {
              name                          = security_rule.value[0]
              priority                      = security_rule.value[1]
              direction                     = security_rule.value[2]
              access                        = security_rule.value[3]
              protocol                      = security_rule.value[4]
              source_port_range             = security_rule.value[5]
              source_port_ranges            = security_rule.value[6]
              source_address_prefix         = security_rule.value[7]
              source_address_prefixes       = security_rule.value[8]
              destination_port_range        = security_rule.value[9]
              destination_port_ranges       = security_rule.value[10]
              destination_address_prefix    = security_rule.value[11]
              destination_address_prefixes  = security_rule.value[12]
    }
  }
}
