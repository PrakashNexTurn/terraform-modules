# Azure Storage Account Module

This module creates an Azure Storage Account with configurable settings for containers, file shares, queues, and tables.

## Features

- Creates Azure Storage Account with customizable SKU and tier
- Supports blob containers with access levels
- Configurable network rules and firewall
- Supports lifecycle management policies
- Enable/disable soft delete for blobs and containers
- Support for static website hosting
- Advanced threat protection support
- Configurable encryption settings

## Usage

```hcl
module "storage_account" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/storage-account?ref=develop"

  # Required variables
  storage_account_name = "mystorageacct"
  resource_group_name  = "my-rg"
  location             = "eastus"

  # Optional configurations
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Blob containers
  containers = [
    {
      name        = "data"
      access_type = "private"
    },
    {
      name        = "logs"
      access_type = "private"
    }
  ]

  # Network rules
  enable_public_access = false
  allowed_ip_ranges    = ["203.0.113.0/24"]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| storage_account_name | Name of the storage account (must be globally unique) | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region | `string` | n/a | yes |
| account_tier | Storage account tier | `string` | `"Standard"` | no |
| account_replication_type | Replication type | `string` | `"LRS"` | no |
| account_kind | Kind of storage account | `string` | `"StorageV2"` | no |
| access_tier | Access tier for BlobStorage accounts | `string` | `"Hot"` | no |
| enable_https_traffic_only | Force HTTPS traffic only | `bool` | `true` | no |
| min_tls_version | Minimum TLS version | `string` | `"TLS1_2"` | no |
| enable_public_access | Allow public access | `bool` | `true` | no |
| allowed_ip_ranges | List of allowed IP ranges | `list(string)` | `[]` | no |
| containers | List of blob containers to create | `list(object)` | `[]` | no |
| enable_blob_soft_delete | Enable soft delete for blobs | `bool` | `true` | no |
| blob_soft_delete_retention_days | Retention days for blob soft delete | `number` | `7` | no |
| enable_container_soft_delete | Enable soft delete for containers | `bool` | `true` | no |
| container_soft_delete_retention_days | Retention days for container soft delete | `number` | `7` | no |
| enable_versioning | Enable blob versioning | `bool` | `false` | no |
| enable_change_feed | Enable blob change feed | `bool` | `false` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| storage_account_id | ID of the storage account |
| storage_account_name | Name of the storage account |
| primary_blob_endpoint | Primary blob endpoint |
| primary_connection_string | Primary connection string (sensitive) |
| container_ids | Map of container names to IDs |

## Examples

See the [examples](./examples/) directory for complete usage examples.
