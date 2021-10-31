# Region and project general configuration
vm_region = "East US 2"

vm_rg_name = "workshop-trt"

vm_vnet_name = "workshop-trt"

vm_subnet_name = "workshop-trt"

vm_environment = "PJe Lab"

vm_count = 4

# VM
base_name = "pjelab"

vm_ip_base = "192.168.1.4"

vm_size = "Standard_D2s_v3"

vm_environment_tag = "PJe Lab"

vm_image_publisher = "OpenLogic"

vm_image_offer = "CentOS"

vm_image_sku = "7_9"

vm_image_version = "latest"

# Disk
vm_disk_caching = "ReadWrite"

vm_disk_create_option = "FromImage"

vm_disk_managed_disk_type = "Standard_LRS"

vm_managed_disk_storage_account_type = "Standard_LRS"

vm_managed_disk_create_option = "Empty"

vm_managed_disk_size = 50

vm_managed_disk_lun_base = 10

vm_profile_user = "trt12"

