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
# Public IP Ingress Externo
resource "azurerm_public_ip" "template_public_ip_lb_ingress_externo" {
  name                = "${var.base_name}-lb-ingress-externo"
  location            = var.vm_region
  resource_group_name = var.vm_rg_name
  allocation_method   = "Dynamic"
  domain_name_label   = "lb-externo-${var.azure_client_id}"
  tags = {
    environment = var.vm_environment_tag
  }
}
# Public IP Ingress Redejt
resource "azurerm_public_ip" "template_public_ip_lb_ingress_redejt" {
  name                = "${var.base_name}-lb-ingress-redejt"
  location            = var.vm_region
  resource_group_name = var.vm_rg_name
  allocation_method   = "Dynamic"
  domain_name_label   = "lb-redejt-${var.azure_client_id}"
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
  frontend_ip_configuration {
    name                 = "ingress-externo"
    public_ip_address_id = azurerm_public_ip.template_public_ip_lb_ingress_externo.id
  }
  frontend_ip_configuration {
    name                 = "ingress-redejt"
    public_ip_address_id = azurerm_public_ip.template_public_ip_lb_ingress_redejt.id
  }
}
#LB Rules
resource "azurerm_lb_rule" "template_lb_ingress_interno_rule_80" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_interno_rule_80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 30080
  frontend_ip_configuration_name = "ingress-interno"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_interno_30080.id
}
resource "azurerm_lb_rule" "template_lb_ingress_interno_rule_443" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_interno_rule_443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 30443
  frontend_ip_configuration_name = "ingress-interno"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_interno_30443.id
}
resource "azurerm_lb_rule" "template_lb_ingress_interno_rule_9101" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_interno_rule_9101"
  protocol                       = "Tcp"
  frontend_port                  = 9101
  backend_port                   = 30101
  frontend_ip_configuration_name = "ingress-interno"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_interno_30101.id
}

resource "azurerm_lb_rule" "template_lb_ingress_externo_rule_80" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_externo_rule_80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 31080
  frontend_ip_configuration_name = "ingress-externo"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_externo_31080.id
}
resource "azurerm_lb_rule" "template_lb_ingress_externo_rule_443" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_externo_rule_443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 31443
  frontend_ip_configuration_name = "ingress-externo"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_externo_31443.id
}
resource "azurerm_lb_rule" "template_lb_ingress_externo_rule_9101" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_externo_rule_9101"
  protocol                       = "Tcp"
  frontend_port                  = 9101
  backend_port                   = 31101
  frontend_ip_configuration_name = "ingress-externo"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_externo_31101.id
}

resource "azurerm_lb_rule" "template_lb_ingress_redejt_rule_80" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_redejt_rule_80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 32080
  frontend_ip_configuration_name = "ingress-redejt"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_redejt_32080.id
}
resource "azurerm_lb_rule" "template_lb_ingress_redejt_rule_443" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_redejt_rule_443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 32443
  frontend_ip_configuration_name = "ingress-redejt"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_redejt_32443.id
}
resource "azurerm_lb_rule" "template_lb_ingress_redejt_rule_9101" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_ingress_redejt_rule_9101"
  protocol                       = "Tcp"
  frontend_port                  = 9101
  backend_port                   = 32101
  frontend_ip_configuration_name = "ingress-redejt"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.template_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.template_lb_probe_redejt_32101.id
}

#LB Probes
resource "azurerm_lb_probe" "template_lb_probe_interno_30080" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_interno_30080"
  port                           = 30080
}
resource "azurerm_lb_probe" "template_lb_probe_interno_30443" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_interno_30443"
  port                           = 30443
}
resource "azurerm_lb_probe" "template_lb_probe_interno_30101" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_interno_30101"
  port                           = 30101
}

resource "azurerm_lb_probe" "template_lb_probe_externo_31080" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_externo_31080"
  port                           = 31080
}
resource "azurerm_lb_probe" "template_lb_probe_externo_31443" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_externo_31443"
  port                           = 31443
}
resource "azurerm_lb_probe" "template_lb_probe_externo_31101" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_externo_31101"
  port                           = 31101
}

resource "azurerm_lb_probe" "template_lb_probe_redejt_32080" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_redejt_32080"
  port                           = 32080
}
resource "azurerm_lb_probe" "template_lb_probe_redejt_32443" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_redejt_32443"
  port                           = 32443
}
resource "azurerm_lb_probe" "template_lb_probe_redejt_32101" {
  resource_group_name            = var.vm_rg_name
  loadbalancer_id                = azurerm_lb.template_lb.id
  name                           = "${var.base_name}-lb_probe_redejt_32101"
  port                           = 32101
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