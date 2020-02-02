variable "prefix" {
  description = "(Required) prefix"   
}

variable "vm_size" {

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

variable "private_ip_address" {
  description = "private IP address of fortimanager"
}

variable "subnet_id" {
  description = "subnet ID of subnet"
}

variable "admin_username" {

}

variable "admin_password" {

}

variable "boot_diagnostics_endpoint" {
  default = null
}

variable "recovery_vault_name" {
  default = null
}

