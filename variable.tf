variable "azure_region" {
  type        = string
  description = "Azureのリージョン"
  default     = "japaneast"
}

variable "azure_rg_name" {
  description = "Azure Resource Groupの名前"
  type        = string
}

variable "azure_subscription_id" {
  type        = string
  description = "AzureのサブスクリプションID"
  sensitive   = true
}

variable "azure_tenant_id" {
  type        = string
  description = "AzureのテナントID"
  sensitive   = true
}

variable "azure_client_id" {
  type        = string
  description = "AzureのクライアントID"
  sensitive   = true
}

variable "azure_client_secret" {
  type        = string
  description = "Azureのクライアントシークレット"
  sensitive   = true
}

variable "azure_vnet_cidr" {
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
  description = "AzureにデプロイするPSEのプロビジョニングキー"
  type        = string
 }

variable "azure_psevm_instance_type" {
  description = "AzureにデプロイするPSEのインスタンスタイプ"
  type        = string
  default     = "Standard_D4s_v3"
  validation {
    condition = (
      var.azure_psevm_instance_type == "Standard_D4s_v3" ||
      var.azure_psevm_instance_type == "Standard_F4s_v2"
    )
    error_message = "Input psevm_instance_type must be set to an approved vm size."
  }
}

variable "azure_psevm_image_publisher" {
  description = "AzureにデプロイするPSEのイメージ発行元"
  type        = string
  default     = "center-for-internet-security-inc"
}

variable "azure_psevm_image_offer" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Offer"
  default     = "cis-centos"
}

variable "azure_psevm_image_sku" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image SKU"
  default     = "cis-centoslinux7-l1-gen1"
}

variable "azure_psevm_image_version" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Version"
  default     = "latest"
}

variable "azure_pse_username" {
  type        = string
  description = "Default Private Service Edge admin/root username"
  default     = "zpse-admin"
}

variable "azure_tls_key_algorithm" {
  type        = string
  description = "algorithm for tls_private_key resource"
  default     = "RSA"
}

variable "azure_client_image_publisher" {
  description = "AzureにデプロイするWindowsクライアントのイメージ発行元"
  type        = string
  default     = "microsoftwindowsdesktop"
}

variable "azure_client_image_offer" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Offer"
  default     = "windows-10"
}

variable "azure_client_image_sku" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image SKU"
  default     = "win10-22h2-pro"
}

variable "azure_client_image_version" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Version"
  default     = "latest"
}

variable "azure_ac_provision_key" {
  description = "AzureにデプロイするApp Connectorのプロビジョニングキー"
  type        = string
}

variable "azure_acvm_instance_type" {
  description = "AzureにデプロイするApp Connectorのインスタンスタイプ"
  type        = string
  default     = "Standard_D4s_v3"
  validation {
    condition = (
      var.azure_acvm_instance_type == "Standard_D4s_v3" ||
      var.azure_acvm_instance_type == "Standard_F4s_v2"
    )
    error_message = "Input acvm_instance_type must be set to an approved vm size."
  }
}

variable "azure_ac_username" {
  type        = string
  description = "Default App Connector admin/root username"
  default     = "zsroot"
}

variable "azure_acvm_image_publisher" {
  description = "AzureにデプロイするApp Connectorのイメージ発行元"
  type        = string
  default     = "zscaler"
}

variable "azure_acvm_image_offer" {
  type        = string
  description = "Azure Marketplace Zscaler App Connector Image Offer"
  default     = "zscaler-private-access"
}

variable "azure_acvm_image_sku" {
  type        = string
  description = "Azure Marketplace Zscaler App Connector Image SKU"
  default     = "zpa-con-azure"
}

variable "azure_acvm_image_version" {
  type        = string
  description = "Azure Marketplace App Connector Image Version"
  default     = "latest"
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

variable "azure_ac_group" {
  type        = string
  description = "App Connector Groupの名前"
}