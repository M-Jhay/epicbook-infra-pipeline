variable "rg_name" {
  description = "Resource group name"
  type        = string
  default     = "epicbook-rg"
}

variable "rg_location" {
  description = "Azure region"
  type        = string
  default     = "South Africa North"
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "Subnet prefix"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_B2ts_v2"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "jecinta"  
}

variable "public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "C:/Users/DELL/.ssh/ReactAppKey.pub"
}


variable "db_admin_username" {
  description = "MySQL admin username"
  type        = string
}

variable "db_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
}
