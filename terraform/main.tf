# Azure provider
provider "azurerm" {
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  version         = "=2.0.0"
  features {}
}

# Get Data
data "azurerm_subnet" "template_subnet" {
  name                 = var.vm_subnet_name
  virtual_network_name = var.vm_vnet_name
  resource_group_name  = var.vm_rg_name
}

# NIC
resource "azurerm_network_interface" "template_nic" {
  count               = var.vm_count
  name                = "${var.base_name}-${format("%02d", count.index)}-NIC"
  location            = var.vm_region
  resource_group_name = var.vm_rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.template_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.vm_ip_base}${format("%01d", count.index)}"
  }
}

# Availability_setting
resource "azurerm_availability_set" "template_avset" {
 name                         = "${var.base_name}-avset"
 location                    = var.vm_region
 resource_group_name         = var.vm_rg_name
 platform_fault_domain_count  = 1
 platform_update_domain_count = 1
 managed                      = true
}

# VM
resource "azurerm_virtual_machine" "template_vm" {
  count                         = var.vm_count
  name                          = "${var.base_name}-${format("%02d", count.index)}"
  location                      = var.vm_region
  availability_set_id           = azurerm_availability_set.template_avset.id
  resource_group_name           = var.vm_rg_name
  network_interface_ids         = [element(azurerm_network_interface.template_nic.*.id, count.index)]
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  storage_os_disk {
    name              = "${var.base_name}-osdisk-${format("%02d", count.index)}"
    caching           = var.vm_disk_caching
    create_option     = var.vm_disk_create_option
    managed_disk_type = var.vm_disk_managed_disk_type
  }

  os_profile {
    computer_name  = "${var.base_name}-${format("%02d", count.index)}"
    admin_username = var.vm_profile_user
  }
  
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.vm_profile_user}/.ssh/authorized_keys"
      key_data = var.azure_nodes_admin_ssh_pubkey
    }
  }

  tags = {
    environment = var.vm_environment_tag
  }
}

resource "azurerm_managed_disk" "template_managed_disk" {
  count                = var.vm_count
  name                 = "${var.base_name}-datadisk-${format("%02d", count.index)}"
  location             = var.vm_region
  resource_group_name  = var.vm_rg_name
  storage_account_type = var.vm_managed_disk_storage_account_type
  create_option        = var.vm_managed_disk_create_option
  disk_size_gb         = var.vm_managed_disk_size
  tags = { 
    environment = var.vm_environment_tag
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "template_managed_disk_attach" {
  count              = var.vm_count
  managed_disk_id    = element(azurerm_managed_disk.template_managed_disk.*.id, count.index)
  virtual_machine_id = element(azurerm_virtual_machine.template_vm.*.id, count.index)
  lun                = var.vm_managed_disk_lun_base + count.index
  caching            = var.vm_disk_caching
}
#LB Setup
# Public IP Ingress Interno
resource "azurerm_public_ip" "template_public_ip_lb_ingress_interno" {
  name                = "${var.base_name}-lb-ingress-interno"
  location            = var.vm_region
  resource_group_name = var.vm_rg_name
  allocation_method   = "Dynamic"
  domain_name_label   = "lb-interno-${var.azure_client_id}"
  tags = {
    environment = var.vm_environment_tag
  }
}
#LB Frontend
resource "azurerm_lb" "template_lb" {
  name                = "${var.base_name}-lb"
  location            = var.vm_region
  resource_group_name = var.vm_rg_name

  frontend_ip_configuration {
    name                 = "ingress-interno"
    public_ip_address_id = azurerm_public_ip.template_public_ip_lb_ingress_interno.id
  }
}
#LB Rules
resource "azurerm_lb_rule" "template_lb_ingress_interno_rule_80" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_interno_rule_80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "ingress-interno"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_interno_80.id
}
resource "azurerm_lb_rule" "template_lb_ingress_interno_rule_443" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_interno_rule_443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "ingress-interno"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_interno_443.id
}
#LB Probes
resource "azurerm_lb_probe" "template_lb_probe_interno_80" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_interno_80"
  port                           = 80
}
resource "azurerm_lb_probe" "template_lb_probe_interno_443" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_interno_443"
  port                           = 443
}
#LB Backend Address pool
resource "azurerm_lb_backend_address_pool" "template_lb_backend_address_pool" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_backend_address_pool"
}
#LB Backend Address Pool Association
resource "azurerm_network_interface_backend_address_pool_association" "template_lb_pool_association" {
  count                          = var.vm_count
  network_interface_id           = element(azurerm_network_interface.template_nic.*.id, count.index)
  ip_configuration_name          = "internal"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
}
