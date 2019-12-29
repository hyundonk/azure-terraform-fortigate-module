variable "service" {
  description = "service object"
  type = object({
    name              = string
    vm_num            = number
    vm_size           = string
    subnet            = string
    subnet_ip_offset  = number
    vm_publisher      = string
    vm_offer          = string
    vm_sku            = string
    vm_version        = string
  })
}

variable "prefix" {
  description = "(Required) prefix name"   
}

variable "subnet_ids_map" {
  description = "map of subnet ids"
}

variable "subnet_prefix_map" {
  description = "map of subnet prefixes"
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

variable "load_balancer_param" {
  description = "load balancer parameters"
  default = null
}

variable "admin_username" {
  description = "admin username of VMs"
}

variable "admin_password" {
  description = "admin password of VMs"
}

variable "custom_data" {
  description = "custom_data for cloud-init"
  default = null
}

variable "boot_diagnostics_endpoint" {
          description = "blob storage URL for boot diagnostics"
}

variable "diag_storage_account_name"        {
          description = "storage account name for diagnostics log"
}

variable "diag_storage_account_access_key"  {
          description = "storage account access key for diagnostics log"
}

variable "log_analytics_workspace_id"  {
          description = "log analytics workspace ID for diagnostics log"
}

variable "log_analytics_workspace_key"  {
          description = "log analytics workspace key for diagnostics log"
}       

variable "enable_network_watcher_extension" {
  description = "true to install network watcher extension" 
  default     = false
}

variable "enable_dependency_agent" {
  description = "true to install dependency agent" 
  default     = false
}

variable "route_table_id" {
          description = "route table id" 
          default = null
}

