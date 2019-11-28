resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  for_each                          = azurerm_public_ip.public_ip

	name                              = "${each.value.name}-diag"
  target_resource_id                = each.value.id

  eventhub_name                     = var.diagnostics_map.eh_name
  eventhub_authorization_rule_id    = "${var.diagnostics_map.eh_id}/authorizationrules/RootManageSharedAccessKey"

  log_analytics_workspace_id        = var.log_analytics_workspace_id

# NOTE: This setting will only have an effect if a log_analytics_workspace_id is provided, and the resource is available for resource-specific logs. As of July 2019, this only includes Azure Data Factory. Please see the documentation for more information.
# log_analytics_destination_type    = "Dedicated"

  storage_account_id                = var.diagnostics_map.diags_sa

  dynamic "log" {
    for_each = var.diagnostics_settings.log
    content {
      category    = log.value[0]
      enabled =     log.value[1]
      retention_policy {
        enabled =     log.value[2]
        days    = log.value[3]
      }
    }
  }   

  dynamic "metric" {
    for_each = var.diagnostics_settings.metric
    content {
      category    = metric.value[0]
      enabled =     metric.value[1]
      retention_policy {
        enabled =     metric.value[2]
        days    = metric.value[3]
      }
    }
  }
}  


