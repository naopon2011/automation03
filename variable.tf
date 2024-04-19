variable "aws_region" {
  type        = string
  description = "AWSのリージョン"
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "VPCで使用するアドレス帯"
  type        = string
  default     = "10.0.0.0/16"
}

variable "pub_subnet_cidr" {
  description = "パブリックサブネットで使用するアドレス帯"
  type        = string
  default     = "10.0.0.0/24"
}

variable "pri1_subnet_cidr" {
  description = "プライベートサブネット１で使用するアドレス帯"
  type        = string
  default     = "10.0.1.0/24"
}

variable "pri2_subnet_cidr" {
  description = "プライベートサブネット2で使用するアドレス帯"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az1_name" {
  description = "一つ目のavailability zone"
  type        = string
  default     = "ap-northeast-1a"
}

variable "win_ami" {
  description = "Windows(踏み台用)のami(踏み台用)"
  type        = string
  default     = "ami-06323ff1c3178cee1"
}

variable "win_instance_type" {
  description = "Windows(踏み台用)のinstance type"
  type        = string
  default     = "t3.medium"
}

variable "ac_ami" {
  description = "App Connectorのami"
  type        = string
  default     = "ami-05b60713705a935c2"
}

variable "ac_instance_type" {
  description = "App Connectorのinstance type"
  type        = string
  default     = "t3.medium"
}

variable "pse_ami" {
  description = "Cloud Connectorのami"
  type        = string
  default     = "ami-0f210174dd0a67269"
}

variable "pse_instance_type" {
  description = "PSEのinstance type"
  type        = string
  default     = "t3a.large"
}

variable "pse_provision_key" {
  description = "PSE用のProvisioning Keyの名前"
  type        = string
}

variable "zpa_client_id" {
  type        = string
  description = "Zscaler Private Access Client ID"
  sensitive   = true
}

variable "zpa_client_secret" {
  type        = string
  description = "Zscaler Private Access Secret ID"
  sensitive   = true
}

variable "zpa_customer_id" {
  type        = string
  description = "Zscaler Private Access Tenant ID"
}

variable "ac_group" {
  type        = string
  description = "App Connector Groupの名前"
}

variable "provision_key" {
  description = "App Connector用のProvisioning Keyの名前"
  type        = string
}

variable "name_prefix" {
  type        = string
  description = "The name prefix for all your resources"
  default     = "zsdemo"
}

variable "azure_region" {
  type        = string
  description = "Azureのリージョン"
  default     = "japaneast"
}

variable "rg_name" {
  description = "Azure Resource Groupの名前"
  type        = string
}

variable "subscription_id" {
  type        = string
  description = "AzureのサブスクリプションID"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "AzureのテナントID"
  sensitive   = true
}

variable "client_id" {
  type        = string
  description = "AzureのクライアントID"
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Azureのクライアントシークレット"
  sensitive   = true
}

variable "vnet_cidr" {
  description = "Azure vNETで使用するアドレス帯"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azure_pub_subnet_cidr" {
  description = "パブリックサブネットで使用するアドレス帯"
  type        = string
  default     = "10.0.0.0/24"
}

variable "azure_pri1_subnet_cidr" {
  description = "プライベートサブネット１で使用するアドレス帯"
  type        = string
  default     = "10.0.1.0/24"
}

variable "azure_pri2_subnet_cidr" {
  description = "プライベートサブネット2で使用するアドレス帯"
  type        = string
  default     = "10.0.2.0/24"
}

variable "azure_pse_provision_key" {
  description = "PSEのプロビジョニングキー"
  type        = string
  default = "3|api.private.zscaler.com|BqfbomqyrwD3PmbI+wTAhXuArRCDuEl/ywb/t0Op5G3X0NQGCVGPbvhpX5oPu9TjB7qyUsKKcQtbScNLyJcjyWL0tKqYGBraEjAb333/r2G2eKqHl9Qi2E2WPDb0F/jsQR2hhmiACmowj7wyiyFz0HJAlpEOJVxRYgV9Bc2OZkjgFyVPon6bGYNzobxXTbEOiK63PSUNNTWU18Tf5ve4wZFbK4mb34lA2S/XpEiOPNB+ZQ0SC3M3Yj5vHao4tDcfTqLVe075LHDC/ApH/IWYPGzAb66Fmg+qlc77Xgbdf7DZqHQbkqWyxBLZQChuDg4H1d+rLFitYBNpten2vI0VQ5LzZCKjAqPAzFt4TnNTXDkk4tYGNFTUTIJyVIQNahGl"
}
variable "pse_count" {
  description = "PSEのデプロイメントの数"
  type        = number
  default = 1
}

variable "psevm_instance_type" {
  type        = string
  description = "PSE Image size"
  default     = "Standard_D4s_v3"
  validation {
    condition = (
      var.psevm_instance_type == "Standard_D4s_v3" ||
      var.psevm_instance_type == "Standard_F4s_v2"
    )
    error_message = "Input psevm_instance_type must be set to an approved vm size."
  }
}

variable "psevm_image_publisher" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Publisher"
  default     = "center-for-internet-security-inc"
}

variable "psevm_image_offer" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Offer"
  default     = "cis-centos"
}

variable "psevm_image_sku" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image SKU"
  default     = "cis-centoslinux7-l1-gen1"
}

variable "psevm_image_version" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Version"
  default     = "latest"
}

variable "reuse_nsg" {
  type        = bool
  description = "Specifies whether the NSG module should create 1:1 network security groups per instance or 1 network security group for all instances"
  default     = "false"
}

variable "byo_nsg" {
  type        = bool
  description = "Bring your own Network Security Groups for Service Edge"
  default     = false
}

variable "byo_nsg_rg" {
  type        = string
  description = "User provided existing NSG Resource Group. This must be populated if byo_nsg variable is true"
  default     = ""
}

variable "tls_key_algorithm" {
  type        = string
  description = "algorithm for tls_private_key resource"
  default     = "RSA"
}


variable "client_image_publisher" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Publisher"
  default     = "microsoftwindowsdesktop"
}

variable "client_image_offer" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Offer"
  default     = "windows-10"
}

variable "client_image_sku" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image SKU"
  default     = "win10-22h2-pro"
}

variable "client_image_version" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Version"
  default     = "latest"
}

variable "azure_ac_provision_key" {
  description = "App Connectorのプロビジョニングキー"
  type        = string
  default = "3|api.private.zscaler.com|4g2ZAI6CN6EJKs6dZjYWZu/Q2EU0+Z7b+ZolDP8BIMAGMDKSDQJFU22opx1Jo/W3LpMI/Rp54lqugvYOEvydmEHmrNrM5BlS7kF+DVap0MXDJs4OuJvzXRP57dFp8jZq+VBAKF0Gmtq7nDbBR4s7PXQHeeHaS8BEm2hZdDHJHzT58kVZaJJkdB7q765M94KwVXDKEpupX5xInyyCG1hfSsHqQYcbijusyJ2Jq5FHxXPvYLdkVLcqrNpRtyWKyAoKzmb9NF8lWWsIDkF+46o1QrLjVwJm4YpJNRdncJ2Pqvwnq2+wZNUPMCSdhIE1v8PQFzjklZG/iizY4E+75eM0OaZMfraxK7M90CCURw3fpQjyvFySLj/u7U3k99gm70o9"
}

variable "ac_count" {
  description = "App Connectorのプロビジョニング数"
  type        = number
  default = 1
}

variable "acvm_instance_type" {
  type        = string
  description = "App Connector Image size"
  default     = "Standard_D4s_v3"
  validation {
    condition = (
      var.acvm_instance_type == "Standard_D4s_v3" ||
      var.acvm_instance_type == "Standard_F4s_v2"
    )
    error_message = "Input acvm_instance_type must be set to an approved vm size."
  }
}

variable "ac_username" {
  type        = string
  description = "Default App Connector admin/root username"
  default     = "zsroot"
}

variable "ssh_key" {
  type        = string
  description = "SSH Key for instances"
  default = "test"
}

variable "acvm_image_publisher" {
  type        = string
  description = "Azure Marketplace Zscaler App Connector Image Publisher"
  default     = "zscaler"
}

variable "acvm_image_offer" {
  type        = string
  description = "Azure Marketplace Zscaler App Connector Image Offer"
  default     = "zscaler-private-access"
}

variable "acvm_image_sku" {
  type        = string
  description = "Azure Marketplace Zscaler App Connector Image SKU"
  default     = "zpa-con-azure"
}

variable "acvm_image_version" {
  type        = string
  description = "Azure Marketplace App Connector Image Version"
  default     = "latest"
}

variable "pse_username" {
  type        = string
  description = "Default Private Service Edge admin/root username"
  default     = "zpse-admin"
}