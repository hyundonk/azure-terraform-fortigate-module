variable "prefix" {
  description = "(Required) prefix name"   
}

variable "name" {
  description = "(Required) service (middle) name"   
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

variable "load_balancer_sku" {
  description = "(Required) load balancer sku. Standard or Basic"
}

variable "subnet_prefix" {
  description = "subnet prefix"
}

variable "subnet_ip_offset" {
  description = "ip offset in subnet for internal load balancer frontend IP address"
}

variable "subnet_id" {
  description = "subnet ID for the internal load balancer"
}

variable "load_balancer_probe_protocol" {
  description = "probe protocol. Http, Https, or Tcp"
  default   = "Tcp"
}

variable "load_balancer_probe_port" {
  description = "probe port. (1 ~ 65535)"
  default   = "22"
}

variable "load_balancer_probe_interval" {
  description = "probe interval in sec."
  default   = "5"
}

variable "load_balancer_number_of_probes" {
  description = "number of probes"
  default   = "2"
}

variable "vm_num" {
          description = "Number of VMs to create"        
}

variable "vm_size" {
          description = "VM size"
}

variable "vm_publisher" {
            default = "MicrosoftWindowsServer"
}

variable "vm_offer" {
            default = "WindowsServer"
}

variable "vm_sku" {
            default = "2016-Datacenter"
}

variable "vm_version" {
            default = "latest"
}

variable "admin_username" {
  description = "admin username of VMs"
}

variable "admin_password" {
  description = "admin password of VMs"
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
}

variable "enable_dependency_agent" {
          description = "true to install dependency agent" 
}

