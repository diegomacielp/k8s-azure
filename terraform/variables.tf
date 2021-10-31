###############################
# Azure connection parameters #
###############################
variable "azure_subscription_id" {
    type = string
}
variable "azure_tenant_id" {
    type = string
}
variable "azure_client_id" {
    type = string
}                                  
variable "azure_client_secret" {
    type = string
}                                    
variable "azure_nodes_admin_ssh_pubkey" {
    type = string
}

##################################################
# Azure Region and project general configuration #
##################################################
variable "vm_region" {
    type = string
}
variable "vm_rg_name" {
    type = string
}
variable "vm_vnet_name" {
    type = string
}
variable "vm_subnet_name" {
    type = string
}

#################
# VM parameters #
#################
variable "base_name" {
    type = string
}
variable "vm_environment" {
    type = string
}
variable "vm_count" {
    type = number
}
variable "vm_ip_base" {
    type = string
}
variable "vm_size" {
    type = string
}
variable "vm_environment_tag" {
    type = string
}
variable "vm_image_publisher" {
    type = string
}
variable "vm_image_offer" {
    type = string
}
variable "vm_image_sku" {
    type = string
}
variable "vm_image_version" {
    type = string
}
variable "vm_disk_caching" {
    type = string
}
variable "vm_disk_create_option" {
    type = string
}
variable "vm_disk_managed_disk_type" {
    type = string
}
variable "vm_managed_disk_storage_account_type" {
    type = string
}
variable "vm_managed_disk_create_option" {
    type = string
}
variable "vm_managed_disk_size" {
    type = number
}
variable "vm_managed_disk_lun_base" {
    type = number
}
variable "vm_profile_user" {
    type = string
}

#############
# Terraform #
#############
variable "terraform_backend" {
    type = string
}
