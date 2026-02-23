# Azure Virtual Machine Module

This module creates an Azure Virtual Machine with all necessary networking dependencies including Virtual Network, Subnet, Network Interface, and Public IP.

## Features

- Creates Virtual Network and Subnet
- Configures Network Security Group with customizable rules
- Creates Public IP (optional)
- Creates Network Interface
- Deploys Virtual Machine with customizable size and OS
- Supports both Linux and Windows VMs
- OS Disk encryption support

## Usage

```hcl
module "virtual_machine" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=develop"

  # Required variables
  resource_group_name = "my-rg"
  location            = "eastus"
  vm_name             = "my-vm"
  vm_size             = "Standard_DS2_v2"
  admin_username      = "azureuser"
  admin_password      = "P@ssw0rd1234!"  # Use Azure Key Vault in production

  # Networking
  vnet_name          = "my-vnet"
  vnet_address_space = ["10.0.0.0/16"]
  subnet_name        = "my-subnet"
  subnet_address_prefix = ["10.0.1.0/24"]

  # Optional
  create_public_ip = true
  os_disk_size_gb  = 128

  tags = {
    Environment = "Development"
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
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region | `string` | n/a | yes |
| vm_name | Name of the virtual machine | `string` | n/a | yes |
| vm_size | Size of the virtual machine | `string` | `"Standard_DS2_v2"` | no |
| admin_username | Admin username for the VM | `string` | n/a | yes |
| admin_password | Admin password for the VM | `string` | n/a | yes |
| vnet_name | Name of the virtual network | `string` | n/a | yes |
| vnet_address_space | Address space for VNet | `list(string)` | n/a | yes |
| subnet_name | Name of the subnet | `string` | n/a | yes |
| subnet_address_prefix | Address prefix for subnet | `list(string)` | n/a | yes |
| create_public_ip | Whether to create a public IP | `bool` | `false` | no |
| os_disk_size_gb | Size of OS disk in GB | `number` | `128` | no |
| os_disk_storage_account_type | Storage account type for OS disk | `string` | `"Premium_LRS"` | no |
| source_image_publisher | OS image publisher | `string` | `"Canonical"` | no |
| source_image_offer | OS image offer | `string` | `"0001-com-ubuntu-server-jammy"` | no |
| source_image_sku | OS image SKU | `string` | `"22_04-lts-gen2"` | no |
| source_image_version | OS image version | `string` | `"latest"` | no |
| nsg_rules | List of NSG rules | `list(object)` | See default | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vm_id | ID of the virtual machine |
| vm_name | Name of the virtual machine |
| vm_private_ip | Private IP address of the VM |
| vm_public_ip | Public IP address of the VM (if created) |
| vnet_id | ID of the virtual network |
| subnet_id | ID of the subnet |
| network_interface_id | ID of the network interface |

## Examples

See the [examples](./examples/) directory for complete usage examples.
