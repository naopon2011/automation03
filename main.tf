terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    zpa = {
      source = "zscaler/zpa"
      version = "~> 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.azure_region
}

resource "azurerm_network_security_group" "security_group" {
  name                = "security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_cidr]
 # dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" pub_subnet {
  name           = "pub_subnet"
  address_prefixes = [var.azure_pub_subnet_cidr]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" pri_subnet1 {
  name           = "pri_subnet1"
  address_prefixes = [var.azure_pri1_subnet_cidr]
  resource_group_name = azurerm_resource_group.rg.name
   virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" pri_subnet2 {
  name           = "pri_subnet2"
  address_prefixes = [var.azure_pri2_subnet_cidr]
  resource_group_name = azurerm_resource_group.rg.name
   virtual_network_name = azurerm_virtual_network.vnet.name
}

# public subnet用のルーティングテーブル
resource "azurerm_route_table" "public_route_table" {
  name         = "public_route_table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# デフォルトルートをインターネットゲートウェイに設定
resource "azurerm_route" "public_route" {
  name         = "public_route"
  resource_group_name = azurerm_resource_group.rg.name
  route_table_name = azurerm_route_table.public_route_table.name
  address_prefix = "0.0.0.0/0"
  next_hop_type = "Internet"
}

#ルーティングテーブルをサブネットに紐付け
resource "azurerm_subnet_route_table_association" "public" {
  subnet_id = azurerm_subnet.pub_subnet.id
  route_table_id = azurerm_route_table.public_route_table.id
}

# private subnet用のルーティングテーブル
resource "azurerm_route_table" "private_route_table" {
  name         = "private_route_table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "tls_private_key" "key" {
  algorithm = var.tls_key_algorithm
}

# デフォルトルートをCCに設定
#resource "azurerm_route" "public_route" {
#  name         = "private_route"
#  resource_group_name = azurerm_resource_group.rg.name
#  route_table_name = azurerm_route_table.private_route_table
#  address_prefix = "0.0.0.0/0"
#  next_hop_type = "Virtual Applicance"
#  next_hop_in_ip_address
#}

#ルーティングテーブルをサブネットに紐付け
#resource "azurerm_subnet_route_table_association" "private1" {
#  subnet_id = azurerm_virtual_network.vnet.subnet.pri_subnet1.ID
#  route_table_id = azurerm_route_table.private_route_table.id
#}

#resource "azurerm_subnet_route_table_association" "private2" {
#  subnet_id = azurerm_virtual_network.vnet.subnet.pri_subnet2.ID
#  route_table_id = azurerm_route_table.private_route_table.id
#}
