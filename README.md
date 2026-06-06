# Terraform Azure Modules

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-blue)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Azure-Provider%203.0+-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This repository contains reusable Terraform modules for Azure infrastructure components. These modules are designed to be invoked from other repositories, promoting infrastructure as code best practices and reusability.

## 📦 Available Modules

### 1. Virtual Machine Module
Creates an Azure Virtual Machine with all networking dependencies including VNet, Subnet, NSG, and optional Public IP.

**Path:** `azure/virtual-machine`

**Features:**
- Complete networking stack (VNet, Subnet, NSG)
- Configurable VM sizes and OS images
- Optional public IP
- Customizable security rules
- Auto-scaling support

[📖 Documentation](./azure/virtual-machine/README.md) | [💡 Examples](./azure/virtual-machine/examples/)

---

### 2. Storage Account Module
Creates an Azure Storage Account with configurable containers, encryption, and network rules.

**Path:** `azure/storage-account`

**Features:**
- Multiple container support
- Soft delete and versioning
- Network rules and firewall
- Lifecycle management
- Advanced threat protection

[📖 Documentation](./azure/storage-account/README.md) | [💡 Examples](./azure/storage-account/examples/)

---

### 3. Azure Kubernetes Service (AKS) Module
Creates a production-ready AKS cluster with configurable node pools and networking.

**Path:** `azure/aks`

**Features:**
- Multiple node pools with auto-scaling
- Azure CNI or Kubenet networking
- RBAC and Azure Policy integration
- Private cluster support
- System-assigned managed identity

[📖 Documentation](./azure/aks/README.md) | [💡 Examples](./azure/aks/examples/)

---

## 🚀 Quick Start

### Using a Module from Another Repository

```hcl
module "virtual_machine" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=develop"

  resource_group_name   = "my-resource-group"
  location              = "eastus"
  vm_name               = "my-vm"
  vm_size               = "Standard_B2s"
  admin_username        = "azureadmin"
  admin_password        = var.admin_password
  
  vnet_name             = "my-vnet"
  vnet_address_space    = ["10.0.0.0/16"]
  subnet_name           = "my-subnet"
  subnet_address_prefix = ["10.0.1.0/24"]
  
  create_public_ip = true
  
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
```

### Module Source Format

```
git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/<module_name>?ref=<branch|tag|commit>
```

**Components:**
- `git::` - Git source prefix
- Repository URL
- `//azure/<module_name>` - Module path
- `?ref=<reference>` - Branch, tag, or commit SHA

## 📚 Documentation

- **[Usage Guide](./USAGE.md)** - Comprehensive guide on using these modules
- **[Contributing Guide](./CONTRIBUTING.md)** - How to contribute to this repository
- Module-specific documentation in each module's README

## 🏗️ Repository Structure

```
terraform-modules/
├── README.md                          # This file
├── USAGE.md                           # Detailed usage guide
├── CONTRIBUTING.md                    # Contribution guidelines
├── LICENSE                            # License information
└── azure/
    ├── virtual-machine/
    │   ├── README.md                  # Module documentation
    │   ├── main.tf                    # Main configuration
    │   ├── variables.tf               # Input variables
    │   ├── outputs.tf                 # Output values
    │   ├── versions.tf                # Version constraints
    │   └── examples/
    │       └── complete/
    │           └── README.md          # Usage example
    ├── storage-account/
    │   ├── README.md
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── versions.tf
    │   └── examples/
    │       └── complete/
    │           └── README.md
    └── aks/
        ├── README.md
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── versions.tf
        └── examples/
            └── complete/
                └── README.md
```

## 🔧 Prerequisites

- **Terraform** >= 1.0
- **Azure Provider** >= 3.0
- **Azure CLI** (for authentication)
- **Azure Subscription** with appropriate permissions

## 🎯 Version Pinning (Recommended)

For production environments, always pin to a specific version:

```hcl
# Development (latest changes)
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=develop"

# Production (specific version)
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=v1.0.0"

# Specific commit (for rollbacks)
source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=abc123def"
```

## 💡 Examples

### Complete Infrastructure Deployment

```hcl
# Deploy all three modules together
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

resource "azurerm_resource_group" "main" {
  name     = "rg-production"
  location = "eastus"
}

module "storage" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/storage-account?ref=develop"
  
  storage_account_name = "mystorageacct001"
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  # ... additional configuration
}

module "vm" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/virtual-machine?ref=develop"
  
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vm_name             = "app-vm-001"
  # ... additional configuration
}

module "aks" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/aks?ref=develop"
  
  cluster_name        = "aks-cluster"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  # ... additional configuration
}
```

More examples available in each module's `examples/` directory.

## 🤝 Contributing

Contributions are welcome! Please see our [Contributing Guide](./CONTRIBUTING.md) for details.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-module`)
3. Make your changes
4. Test your changes
5. Commit with conventional commits (`git commit -m "feat: add new feature"`)
6. Push to your fork
7. Create a Pull Request to `develop` branch

## 📋 Roadmap

Future modules planned:
- Azure SQL Database
- Azure App Service
- Azure Key Vault
- Azure Application Gateway
- Azure Functions
- Azure Container Instances

## 🐛 Issues and Support

- **Bug Reports:** Open an issue with the `bug` label
- **Feature Requests:** Open an issue with the `enhancement` label
- **Questions:** Use the `question` label

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)

## ✨ Acknowledgments

- Built with ❤️ for the infrastructure community
- Maintained by the DevOps team
- Contributions from the open-source community

---

**Note:** This repository is under active development. Please check back for updates and new modules.

For detailed usage instructions, see [USAGE.md](./USAGE.md).
