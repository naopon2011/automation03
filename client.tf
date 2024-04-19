#Create Network Security Group for Client
resource "azurerm_network_security_group" "win_nsg" {
  name                = "win-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "web_http"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "web_https"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {"Name" = var.rg_name}

}

# Create network interface
resource "azurerm_network_interface" "source_client_nic" {
  name                = "win-source_nic"
  location            = var.azure_region
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "win-source_nic_configuration"
    subnet_id                     = azurerm_subnet.pri_subnet1.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {"Name" = var.rg_name}
}

# Create virtual machine for client
resource "azurerm_windows_virtual_machine" "source_client" {
  name                  = "win-source_client"
  computer_name         = "source"
  admin_username        = "azureuser"
  admin_password        = random_password.password.result
  location              = var.azure_region
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.source_client_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.client_image_publisher
    offer     = var.client_image_offer
    sku       = var.client_image_sku
    version   = var.client_image_version
  }
  
  tags = {"Name" = var.rg_name}

}

resource "azurerm_network_interface_security_group_association" "source_client_nic_association" {
  network_interface_id      = azurerm_network_interface.source_client_nic.id
  network_security_group_id = azurerm_network_security_group.win_nsg.id
}


# Create network interface for target client
resource "azurerm_network_interface" "target_client_nic" {
  name                = "win-target_nic"
  location            = var.azure_region
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "win-target_nic_configuration"
    subnet_id                     = azurerm_subnet.pri_subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create virtual machine for target client
resource "azurerm_windows_virtual_machine" "target_client" {
  name                  = "win-target_client"
  computer_name         = "target"
  admin_username        = "azureuser"
  admin_password        = random_password.password.result
  location              = var.azure_region
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.target_client_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.client_image_publisher
    offer     = var.client_image_offer
    sku       = var.client_image_sku
    version   = var.client_image_version
  }

  tags = {"Name" = var.rg_name}

}

resource "azurerm_network_interface_security_group_association" "target_client_nic_association" {
  network_interface_id      = azurerm_network_interface.target_client_nic.id
  network_security_group_id = azurerm_network_security_group.win_nsg.id
}



resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}
