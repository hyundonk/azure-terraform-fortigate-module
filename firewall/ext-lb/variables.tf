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

variable "frontend_ip_addresses" {
  description = "list of frontend IP addresses"
}

variable "frontend_ip_address_outbound" {
  description = "frontend IP address for outbound"
}

