provider "azurerm" {
  version = "<=1.35.0"
}


terraform {
    backend "azurerm" {
    }
}

data "terraform_remote_state" "landingzone_vdc_level1" {
  backend = "azurerm"
  config = {
    storage_account_name  = var.lowerlevel_storage_account_name
    container_name        = var.lowerlevel_container_name 
    resource_group_name   = var.lowerlevel_resource_group_name
    key                   = "tranquility.tfstate"
  }
}

data "terraform_remote_state" "networking" {
  backend = "azurerm"
  config = {
    storage_account_name  = var.lowerlevel_storage_account_name
    container_name        = var.lowerlevel_container_name 
    resource_group_name   = var.lowerlevel_resource_group_name
    key                   = "network.tfstate"
  }
}

locals {
    prefix                    = data.terraform_remote_state.landingzone_vdc_level1.outputs.prefix
    tags                      = data.terraform_remote_state.landingzone_vdc_level1.outputs.tags

    location_map              = data.terraform_remote_state.landingzone_vdc_level1.outputs.location_map
    log_analytics_workspace   = data.terraform_remote_state.landingzone_vdc_level1.outputs.log_analytics_workspace
    diagnostics_map           = data.terraform_remote_state.landingzone_vdc_level1.outputs.diagnostics_map
    resource_group_hub_names  = data.terraform_remote_state.landingzone_vdc_level1.outputs.resource_group_hub_names 
    
    public_ip_prefix          = data.terraform_remote_state.networking.outputs.public_ip_prefix

    subnet_prefix_map         = data.terraform_remote_state.networking.outputs.subnet_prefix_map
    subnet_ids_map            = data.terraform_remote_state.networking.outputs.subnet_ids_map

    admin_username             = var.lowerlevel_fortigate_adminusername
    admin_password             = var.lowerlevel_fortigate_adminpassword
}
