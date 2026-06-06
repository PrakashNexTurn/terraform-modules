# Module Usage Guide

This guide explains how to use the Azure Terraform modules from another repository.

## Prerequisites

- Terraform >= 1.0 installed
- Azure CLI installed and configured
- Azure subscription with appropriate permissions
- Git installed

## General Module Usage Pattern

All modules in this repository can be referenced using the following pattern:

```hcl
module "module_name" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/<module_name>?ref=<branch_or_tag>"
  
  # Module-specific variables
}
```

### Source Format Explanation

- `git::` - Indicates Git repository source
- `https://github.com/PrakashNexTurn/terraform-modules.git` - Repository URL
- `//azure/<module_name>` - Path to the specific module within the repository
- `?ref=<branch_or_tag>` - Git reference (branch, tag, or commit SHA)

### Recommended References

- **Development/Testing**: `?ref=develop`
- **Production**: `?ref=v1.0.0` (use specific version tags)
- **Specific Commit**: `?ref=abc123def` (commit SHA)

## Complete Example: Multi-Module Deployment

Here's an example that uses all three modules together:

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
resource "azurerm_resource_group" "main" {
  name     = "rg-production-eastus"
  location = "eastus"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Deploy Storage Account
module "storage" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/storage-account?ref=develop"

  storage_account_name     = "prodstorageacct001"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  containers = [
    {
      name        = "application-data"
      access_type = "private"
    }
  ]

  tags = azurerm_resource_group.main.tags
}

# Deploy Virtual Machine
module "vm" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=develop"

  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  vm_name               = "prod-app-vm-001"
  vm_size               = "Standard_D2s_v3"
  admin_username        = "azureadmin"
  admin_password        = var.vm_admin_password  # Use variables for sensitive data
  
  vnet_name             = "prod-vnet"
  vnet_address_space    = ["10.0.0.0/16"]
  subnet_name           = "app-subnet"
  subnet_address_prefix = ["10.0.1.0/24"]
  
  create_public_ip      = false  # Private VM
  
  tags = azurerm_resource_group.main.tags
}

# Deploy AKS Cluster
module "aks" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/aks?ref=develop"

  cluster_name        = "prod-aks-cluster"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  dns_prefix          = "prodaks"
  sku_tier            = "Standard"

  default_node_pool = {
    name                = "system"
    node_count          = 3
    vm_size             = "Standard_D2s_v3"
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
  }

  network_plugin = "azure"
  network_policy = "azure"

  tags = azurerm_resource_group.main.tags
}

# Outputs
output "storage_account_id" {
  value = module.storage.storage_account_id
}

output "vm_private_ip" {
  value = module.vm.vm_private_ip
}

output "aks_cluster_fqdn" {
  value = module.aks.cluster_fqdn
}
```

## Using Specific Module Versions

### Option 1: Using Branch References

```hcl
# Development/latest
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=develop"

# Main/stable
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=main"
```

### Option 2: Using Tag References (Recommended for Production)

```hcl
# Specific version tag
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=v1.0.0"

# Semantic versioning
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=v1.2.3"
```

### Option 3: Using Commit SHA

```hcl
# Specific commit (useful for rollbacks)
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=abc123def456"
```

## Best Practices

### 1. Version Pinning

Always pin to specific versions in production:

```hcl
# ❌ Bad - uses latest
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine"

# ✅ Good - pinned version
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=v1.0.0"
```

### 2. Use Variables for Sensitive Data

```hcl
# variables.tf
variable "vm_admin_password" {
  description = "Admin password for VM"
  type        = string
  sensitive   = true
}

# main.tf
module "vm" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=develop"
  
  admin_password = var.vm_admin_password
  # ...
}
```

### 3. Use Terraform Workspaces for Environments

```bash
# Create workspace
terraform workspace new production
terraform workspace new staging

# Switch workspace
terraform workspace select production

# Use workspace in configuration
locals {
  environment = terraform.workspace
}
```

### 4. Remote State Management

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "production.terraform.tfstate"
  }
}
```

## Troubleshooting

### Module Not Found Error

```
Error: Failed to download module
```

**Solution:** Verify the module path and reference:
- Check the module path: `//azure/<module_name>`
- Verify the branch/tag exists
- Ensure you have access to the repository

### Authentication Issues

```
Error: error downloading module: error fetching repository
```

**Solution:** Configure Git credentials:
```bash
# For HTTPS
git config --global credential.helper cache

# For SSH (recommended)
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

### Module Update Not Reflecting

**Solution:** Clear Terraform module cache:
```bash
rm -rf .terraform/modules
terraform init -upgrade
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Terraform Deploy

on:
  push:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: 1.5.0
    
    - name: Azure Login
      uses: azure/login@v2
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    
    - name: Terraform Init
      run: terraform init
    
    - name: Terraform Plan
      run: terraform plan
    
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply -auto-approve
```

## Getting Help

- Review module README files for detailed documentation
- Check the examples directory for each module
- Open an issue in the repository for bugs or questions
- Refer to Azure provider documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

## Module Update Process

When modules are updated:

1. Test changes in development environment using `?ref=develop`
2. Review changes and test thoroughly
3. Tag a new version: `git tag v1.1.0`
4. Update production to use new version: `?ref=v1.1.0`
5. Run `terraform init -upgrade` to fetch new version
