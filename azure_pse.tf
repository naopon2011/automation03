################################################################################
# Make sure that Cloud Connector image terms have been accepted
################################################################################
# resource "azurerm_marketplace_agreement" "zs_image_agreement" {
#   offer     = var.azure_psevm_image_offer
#   plan      = var.azure_psevm_image_sku
#   publisher = var.azure_psevm_image_publisher
# }

locals {
  pse_appuserdata = <<APPUSERDATA
#!/usr/bin/bash
sleep 15
touch /etc/yum.repos.d/zscaler.repo
cat > /etc/yum.repos.d/zscaler.repo <<-EOT
[zscaler]
name=Zscaler Private Access Repository
baseurl=https://yum.private.zscaler.com/yum/el7
enabled=1
gpgcheck=1
gpgkey=https://yum.private.zscaler.com/gpg
EOT
#Install Service Edge packages
yum install zpa-service-edge -y
#Stop the Service Edge service which was auto-started at boot time
systemctl stop zpa-service-edge
#Create a file from the Service Edge provisioning key created in the ZPA Admin Portal
#Make sure that the provisioning key is between double quotes
echo "${var.azure_pse_provision_key}" > /opt/zscaler/var/service-edge/provision_key
#Run a yum update to apply the latest patches
yum update -y
#Start the Service Edge service to enroll it in the ZPA cloud
systemctl start zpa-service-edge
#Wait for the Service Edge to download latest build
sleep 60
#Stop and then start the Service Edge for the latest build
systemctl stop zpa-service-edge
systemctl start zpa-service-edge
APPUSERDATA
}

################################################################################
# Create NSG and Rules for Private Service Edge interfaces
################################################################################
resource "azurerm_network_security_group" "pse_nsg" {
  name                = "pse-nsg"
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

  tags = {"Name" = var.azure_rg_name}
}

################################################################################
# Create PSE Interface and associate NSG
################################################################################
resource "azurerm_network_interface" "pse_nic" {
  name                = "pse-nic"
  location            = var.azure_region
  resource_group_name = var.azure_rg_name

  ip_configuration {
    name                          = "pse-nic_configuration"
    subnet_id                     = azurerm_subnet.pri_subnet2.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  tags = {"Name" = var.azure_rg_name}
}

################################################################################
# Associate PSE interface to NSG
################################################################################
resource "azurerm_network_interface_security_group_association" "pse_nic_association" {
  network_interface_id      = azurerm_network_interface.pse_nic.id
  network_security_group_id = azurerm_network_security_group.pse_nsg.id

  depends_on = [azurerm_network_interface.pse_nic]
}

################################################################################
# Create PSE VM
################################################################################
resource "azurerm_linux_virtual_machine" "pse_vm" {
  name                = "azure-psevm"
  location            = var.azure_region
  resource_group_name = var.azure_rg_name
  size                = var.azure_psevm_instance_type
 # availability_set_id = local.zones_supported == false ? azurerm_availability_set.pse_availability_set[0].id : null
 # zone                = local.zones_supported ? element(var.zones, count.index) : null

  network_interface_ids = [
    azurerm_network_interface.pse_nic.id,
  ]

  computer_name  = "azure-psevm"
  admin_username = var.azure_pse_username
  custom_data    = base64encode(local.pse_appuserdata)

  admin_ssh_key {
    username   = var.azure_pse_username
    public_key = "${trimspace(tls_private_key.key.public_key_openssh)} ${var.azure_pse_username}@me.io"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.azure_psevm_image_publisher
    offer     = var.azure_psevm_image_offer
    sku       = var.azure_psevm_image_sku
    version   = var.azure_psevm_image_version
  }

  plan {
    publisher = var.azure_psevm_image_publisher
    name      = var.azure_psevm_image_sku
    product   = var.azure_psevm_image_offer
  }

  tags = {"Name" = var.azure_rg_name}

  depends_on = [
    azurerm_network_interface_security_group_association.pse_nic_association,
 #    azurerm_marketplace_agreement.zs_image_agreement,
  ]
}
