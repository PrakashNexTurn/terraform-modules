# Example: Azure Storage Account with Containers

This example demonstrates how to use the Storage Account module from another repository.

## Usage

```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "example" {
  name     = "rg-example-storage"
  location = "eastus"
}

# Use the Storage Account module from this repository
module "storage_account" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/storage-account?ref=develop"

  # Storage Account Configuration
  storage_account_name     = "examplestorageacct001"  # Must be globally unique
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  
  # Performance and Replication
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  # Security Settings
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  enable_public_access      = false

  # Network Rules - Allow specific IP ranges
  allowed_ip_ranges = [
    "203.0.113.0/24",
    "198.51.100.0/24"
  ]

  # Blob Containers
  containers = [
    {
      name        = "application-data"
      access_type = "private"
    },
    {
      name        = "logs"
      access_type = "private"
    },
    {
      name        = "backups"
      access_type = "private"
    }
  ]

  # Data Protection
  enable_blob_soft_delete              = true
  blob_soft_delete_retention_days      = 14
  enable_container_soft_delete         = true
  container_soft_delete_retention_days = 14
  enable_versioning                    = true
  enable_change_feed                   = true

  # Tags
  tags = {
    Environment = "Production"
    Project     = "Example"
    ManagedBy   = "Terraform"
    CostCenter  = "IT"
  }
}

# Outputs
output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage_account.storage_account_id
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = module.storage_account.primary_blob_endpoint
}

output "container_ids" {
  description = "Container IDs"
  value       = module.storage_account.container_ids
}

output "primary_connection_string" {
  description = "Primary connection string (sensitive)"
  value       = module.storage_account.primary_connection_string
  sensitive   = true
}
```

## Steps to Run

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the execution plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Get the connection string (if needed):
   ```bash
   terraform output -raw primary_connection_string
   ```

## Clean Up

To destroy the resources:
```bash
terraform destroy
```

## Notes

- Storage account names must be globally unique across Azure
- Use 3-24 lowercase letters and numbers only for storage account names
- Connection strings and access keys are marked as sensitive
- Consider using Private Endpoints for enhanced security in production
- Enable soft delete and versioning for data protection
- Use managed identities instead of connection strings when possible
- Review network rules to ensure appropriate access controls
