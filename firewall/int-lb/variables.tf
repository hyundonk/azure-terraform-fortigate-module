variable "prefix" {
  description = "(Required) prefix"   
}

variable "location" {
  description = "(Required) Location of the public IP to be created"   
}

variable "rg" {
  description = "(Required) Resourge group of the public IP to be created"    
}

variable "tags" {
  description = "(Required) Tags to be applied to the IP address to be created"
  
}

variable "frontend_ip_address" {
  description = "internal load balancer frontend IP address"
}

variable "subnet_id" {
  description = "subnet ID for the internal load balancer"
}

/*
variable "diagnostics_map" {
  description = "(Required) Storage account and Event Hub for the IP address diagnostics"  

}

variable "log_analytics_workspace_id" {
  description = "(Required) Log Analytics ID for the IP address diagnostics"
  
}

variable "diagnostics_settings" {
 description = "(Required) Map with the diagnostics settings for public IP deployment"
}
*/
