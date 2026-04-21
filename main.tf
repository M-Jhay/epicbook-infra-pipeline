terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "CapstoneAgentVm"
    storage_account_name = "jesscapstone2026"
    container_name       = "tfstate-container"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "epicbook_rg" {
  name     = var.rg_name
  location = var.rg_location
}

# Virtual Network
resource "azurerm_virtual_network" "epicbook_vnet" {
  name                = "epicbook-vnet"
  location            = azurerm_resource_group.epicbook_rg.location
  resource_group_name = azurerm_resource_group.epicbook_rg.name
  address_space       = var.address_space
}

# Subnet
resource "azurerm_subnet" "epicbook_subnet" {
  name                 = "epicbook-subnet"
  resource_group_name  = azurerm_resource_group.epicbook_rg.name
  virtual_network_name = azurerm_virtual_network.epicbook_vnet.name
  address_prefixes     = var.subnet_prefix
}

# Network Security Group
resource "azurerm_network_security_group" "epicbook_nsg" {
  name                = "epicbook-nsg"
  location            = azurerm_resource_group.epicbook_rg.location
  resource_group_name = azurerm_resource_group.epicbook_rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "epicbook_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.epicbook_subnet.id
  network_security_group_id = azurerm_network_security_group.epicbook_nsg.id
}

# Public IP
resource "azurerm_public_ip" "epicbook_public_ip" {
  name                = "epicbook-public-ip"
  resource_group_name = azurerm_resource_group.epicbook_rg.name
  location            = azurerm_resource_group.epicbook_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NICs
resource "azurerm_network_interface" "epicbook_nic" {
  name                = "epicbook-nic"
  location            = azurerm_resource_group.epicbook_rg.location
  resource_group_name = azurerm_resource_group.epicbook_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.epicbook_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.epicbook_public_ip.id
  }
}

# VM
resource "azurerm_linux_virtual_machine" "epicbook_vm" {
  name                = "epicbook-vm"
  resource_group_name = azurerm_resource_group.epicbook_rg.name
  location            = azurerm_resource_group.epicbook_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.epicbook_nic.id]

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

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql" {
  name                = "epicbook-mysql"
  resource_group_name = azurerm_resource_group.epicbook_rg.name
  location            = azurerm_resource_group.epicbook_rg.location
  administrator_login          = var.db_admin_username
  administrator_password       = var.db_admin_password
  sku_name                     = "B_Standard_B1ms"
  version                      = "8.0.21"
  zone                         = "2"
}

resource "azurerm_mysql_flexible_database" "epicbook_db" {
  name      = "epicbook-db"
  charset   = "utf8"
  collation = "utf8_general_ci"
  resource_group_name = "${azurerm_resource_group.epicbook_rg.name}"
  server_name = "${azurerm_mysql_flexible_server.mysql.name}"
}
