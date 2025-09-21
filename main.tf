resource "azurerm_resource_group" "rg-b" {
  name     = var.infra_config.rg_name
  location = var.infra_config.rg_location
}

resource "azurerm_virtual_network" "vnet-b" {
  name                = var.infra_config.vnet_name
  location            = var.infra_config.rg_location
  resource_group_name = var.infra_config.rg_name
  address_space       = var.infra_config.address_space
}

resource "azurerm_subnet" "subnet-b" {
  depends_on           = [azurerm_virtual_network.vnet-b]
  name                 = var.infra_config.subnet_name
  resource_group_name  = var.infra_config.rg_name
  virtual_network_name = var.infra_config.vnet_name
  address_prefixes     = var.infra_config.address_prefixes
}

resource "azurerm_network_interface" "nic-b" {
  depends_on          = [azurerm_subnet.subnet-b]
  name                = var.infra_config.nic_name
  location            = var.infra_config.rg_location
  resource_group_name = var.infra_config.rg_name

  ip_configuration {
    name                          = var.infra_config.ip_name
    subnet_id                     = azurerm_subnet.subnet-b.id
    private_ip_address_allocation = var.infra_config.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.public-b.id
  }
}

resource "azurerm_network_security_group" "nsg-b" {
  name                = var.infra_config.nsg_name
  location            = var.infra_config.rg_location
  resource_group_name = var.infra_config.rg_name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_linux_virtual_machine" "vm-b" {
  depends_on          = [azurerm_network_interface.nic-b]
  name                = var.infra_config.vm_name
  resource_group_name = var.infra_config.rg_name
  location            = var.infra_config.rg_location
  size                = var.infra_config.vm_size
  admin_username      = var.infra_config.admin_username
  admin_password      = var.infra_config.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic-b.id,
  ]
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_network_interface_security_group_association" "asso-b" {
  network_interface_id      = azurerm_network_interface.nic-b.id
  network_security_group_id = azurerm_network_security_group.nsg-b.id
}


resource "azurerm_public_ip" "public-b" {
  name                = var.infra_config.pip_name
  resource_group_name = var.infra_config.rg_name
  location            = var.infra_config.rg_location
  allocation_method   = "Static"
}




