# Terraform Azure Modules

This repository contains reusable Terraform modules for Azure infrastructure components.

## Directory Structure

```
azure/
├── virtual-machine/     # Azure VM module with networking dependencies
├── storage-account/     # Azure Storage Account module
└── aks/                 # Azure Kubernetes Service module
```

## Usage

Each module can be invoked from another repository using the following format:

```hcl
module "example" {
  source = "git::https://github.com/PrakashNexTurn/terraform-modules.git//azure/<module_name>?ref=develop"
  
  # Module-specific variables
}
```

## Module Documentation

- [Virtual Machine Module](./azure/virtual-machine/README.md)
- [Storage Account Module](./azure/storage-account/README.md)
- [AKS Module](./azure/aks/README.md)

## Examples

Each module includes an `examples/` directory with practical implementation examples.

## Requirements

- Terraform >= 1.0
- Azure Provider >= 3.0

## Contributing

Please raise a PR to the `develop` branch for any changes.
