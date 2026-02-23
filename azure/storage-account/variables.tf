variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique, 3-24 characters, lowercase letters and numbers only)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 characters long and contain only lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "account_tier" {
  description = "Tier of the storage account (Standard or Premium)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be either Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "Replication type for the storage account (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Account replication type must be LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "account_kind" {
  description = "Kind of storage account (BlobStorage, BlockBlobStorage, FileStorage, Storage, or StorageV2)"
  type        = string
  default     = "StorageV2"

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "Account kind must be BlobStorage, BlockBlobStorage, FileStorage, Storage, or StorageV2."
  }
}

variable "access_tier" {
  description = "Access tier for BlobStorage, FileStorage and StorageV2 accounts (Hot or Cool)"
  type        = string
  default     = "Hot"

  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "Access tier must be either Hot or Cool."
  }
}

variable "enable_https_traffic_only" {
  description = "Force HTTPS traffic only"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Minimum TLS version (TLS1_0, TLS1_1, or TLS1_2)"
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "Minimum TLS version must be TLS1_0, TLS1_1, or TLS1_2."
  }
}

variable "enable_public_access" {
  description = "Allow public access to the storage account"
  type        = bool
  default     = true
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges in CIDR format"
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  description = "List of allowed subnet IDs"
  type        = list(string)
  default     = []
}

variable "containers" {
  description = "List of blob containers to create"
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []

  validation {
    condition = alltrue([
      for container in var.containers : contains(["private", "blob", "container"], container.access_type)
    ])
    error_message = "Container access_type must be private, blob, or container."
  }
}

variable "enable_blob_soft_delete" {
  description = "Enable soft delete for blobs"
  type        = bool
  default     = true
}

variable "blob_soft_delete_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 7

  validation {
    condition     = var.blob_soft_delete_retention_days >= 1 && var.blob_soft_delete_retention_days <= 365
    error_message = "Blob soft delete retention days must be between 1 and 365."
  }
}

variable "enable_container_soft_delete" {
  description = "Enable soft delete for containers"
  type        = bool
  default     = true
}

variable "container_soft_delete_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 7

  validation {
    condition     = var.container_soft_delete_retention_days >= 1 && var.container_soft_delete_retention_days <= 365
    error_message = "Container soft delete retention days must be between 1 and 365."
  }
}

variable "enable_versioning" {
  description = "Enable blob versioning"
  type        = bool
  default     = false
}

variable "enable_change_feed" {
  description = "Enable blob change feed"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
