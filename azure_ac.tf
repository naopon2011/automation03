################################################################################
# Make sure that Cloud Connector image terms have been accepted
################################################################################
#resource "azurerm_marketplace_agreement" "zs_image_agreement" {
#  offer     = var.acvm_image_offer
#  plan      = var.acvm_image_sku
#  publisher = var.acvm_image_publisher
#}

locals {
  ac_appuserdata = <<APPUSERDATA
#!/bin/bash
#Stop the App Connector service which was auto-started at boot time
systemctl stop zpa-connector
#Create a file from the App Connector provisioning key created in the ZPA Admin Portal
#Make sure that the provisioning key is between double quotes
echo "${var.azure_ac_provision_key}" > /opt/zscaler/var/provision_key
#Run a yum update to apply the latest patches
yum update -y
#Start the App Connector service to enroll it in the ZPA cloud
systemctl start zpa-connector
#Wait for the App Connector to download latest build
sleep 60
#Stop and then start the App Connector for the latest build
systemctl stop zpa-connector
systemctl start zpa-connector
APPUSERDATA
}

################################################################################
# Create App Connector Interface and associate NSG
################################################################################
resource "azurerm_network_security_group" "ac_nsg" {
  name                = "ac-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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

################################################################################
# Create App Connector Interface and associate NSG
################################################################################
resource "azurerm_network_interface" "ac_nic" {
  name                = "ac-nic"
  location            = var.azure_region
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ac-nic_configuration"
    subnet_id                     = azurerm_subnet.pri_subnet2.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  tags = {"Name" = var.rg_name}

}

################################################################################
# Associate App Connector interface to NSG
################################################################################
resource "azurerm_network_interface_security_group_association" "ac_nic_association" {
#  count                     = var.ac_count
  network_interface_id      = azurerm_network_interface.ac_nic.id
  network_security_group_id = azurerm_network_security_group.ac_nsg.id

  depends_on = [azurerm_network_interface.ac_nic]
}


################################################################################
# Create App Connector VM
################################################################################
resource "azurerm_linux_virtual_machine" "ac_vm" {
#  count               = var.ac_count
  name                = "azure-acvm"
  location            = var.azure_region
  resource_group_name = var.rg_name
  size                = var.acvm_instance_type
 # availability_set_id = local.zones_supported == false ? azurerm_availability_set.ac_availability_set[0].id : null
 # zone                = local.zones_supported ? element(var.zones, count.index) : null

  network_interface_ids = [
    azurerm_network_interface.ac_nic.id
  ]

  computer_name  = "azure-acvm"
  admin_username = var.ac_username
  custom_data    = base64encode(local.ac_appuserdata)

  admin_ssh_key {
    username   = var.ac_username
    public_key = "${trimspace(tls_private_key.key.public_key_openssh)} ${var.ac_username}@me.io"
 }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.acvm_image_publisher
    offer     = var.acvm_image_offer
    sku       = var.acvm_image_sku
    version   = var.acvm_image_version
  }

  plan {
    publisher = var.acvm_image_publisher
    name      = var.acvm_image_sku
    product   = var.acvm_image_offer
  }
  
  tags = {"Name" = var.rg_name}

  depends_on = [
    azurerm_network_interface_security_group_association.ac_nic_association,
 #   azurerm_marketplace_agreement.zs_image_agreement,
  ]
}
