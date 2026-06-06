# Example: Azure Virtual Machine with Networking

This example demonstrates how to use the Virtual Machine module from another repository.

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
  name     = "rg-example-vm"
  location = "eastus"
}

# Use the VM module from this repository
module "linux_vm" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=develop"

  # Resource Group and Location
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  # VM Configuration
  vm_name        = "example-vm-001"
  vm_size        = "Standard_B2s"
  admin_username = "azureadmin"
  admin_password = "P@ssw0rd1234!"  # Use Azure Key Vault in production

  # Networking Configuration
  vnet_name             = "example-vnet"
  vnet_address_space    = ["10.0.0.0/16"]
  subnet_name           = "example-subnet"
  subnet_address_prefix = ["10.0.1.0/24"]

  # Create public IP for remote access
  create_public_ip = true

  # OS Disk Configuration
  os_disk_size_gb              = 64
  os_disk_storage_account_type = "Standard_LRS"

  # Custom NSG Rules
  nsg_rules = [
    {
      name                       = "allow-ssh"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-http"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  # Tags
  tags = {
    Environment = "Development"
    Project     = "Example"
    ManagedBy   = "Terraform"
  }
}

# Outputs
output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = module.linux_vm.vm_public_ip
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = module.linux_vm.vm_private_ip
}

output "vm_id" {
  description = "Resource ID of the VM"
  value       = module.linux_vm.vm_id
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

4. Connect to the VM:
   ```bash
   ssh azureadmin@<public_ip_address>
   ```

## Clean Up

To destroy the resources:
```bash
terraform destroy
```

## Notes

- Always use Azure Key Vault or environment variables for sensitive data like passwords in production
- Adjust the VM size based on your workload requirements
- Customize NSG rules according to your security requirements
- Consider using SSH keys instead of password authentication for better security
