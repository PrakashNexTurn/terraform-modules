# Contributing to Terraform Azure Modules

Thank you for your interest in contributing to this project! This guide will help you get started.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Module Standards](#module-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Commit Messages](#commit-messages)

## 🤝 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the best solution for the community
- Be patient with new contributors

## 🚀 Getting Started

### Prerequisites

- Terraform >= 1.0
- Azure CLI installed and configured
- Git
- Azure subscription (for testing)
- Text editor or IDE (VS Code recommended)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/terraform-modules.git
   cd terraform-modules
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/PrakashNexTurn/terraform-modules.git
   ```

4. Create a feature branch:
   ```bash
   git checkout -b feature/my-new-feature
   ```

## 🔄 Development Workflow

### Branching Strategy

- `main` - Stable production-ready code
- `develop` - Integration branch for features
- `feature/*` - New features or modules
- `bugfix/*` - Bug fixes
- `hotfix/*` - Emergency fixes for production

### Working on a Feature

1. **Sync with upstream:**
   ```bash
   git checkout develop
   git pull upstream develop
   ```

2. **Create feature branch:**
   ```bash
   git checkout -b feature/new-azure-module
   ```

3. **Make your changes**

4. **Test thoroughly**

5. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add new Azure module for XYZ"
   ```

6. **Push to your fork:**
   ```bash
   git push origin feature/new-azure-module
   ```

7. **Create Pull Request** to `develop` branch

## 📏 Module Standards

### Directory Structure

Each module must follow this structure:

```
azure/<module-name>/
├── README.md          # Module documentation
├── main.tf            # Main resources
├── variables.tf       # Input variables
├── outputs.tf         # Output values
├── versions.tf        # Provider version constraints
└── examples/
    └── complete/
        └── README.md  # Usage example
```

### Required Files

#### 1. README.md

Must include:
- Module description
- Features list
- Usage example
- Requirements table
- Providers table
- Inputs table
- Outputs table
- Link to examples

#### 2. main.tf

- Clear resource definitions
- Logical grouping of resources
- Comments for complex logic
- No hardcoded values

#### 3. variables.tf

```hcl
variable "example_var" {
  description = "Clear description of the variable"
  type        = string
  default     = "default_value"  # If applicable
  
  validation {
    condition     = # validation logic
    error_message = "Clear error message"
  }
}
```

**Variable Standards:**
- Always include description
- Use appropriate types (string, number, bool, list, map, object)
- Add validation blocks where applicable
- Mark sensitive variables with `sensitive = true`
- Provide sensible defaults when possible

#### 4. outputs.tf

```hcl
output "example_output" {
  description = "Clear description of what this output provides"
  value       = azurerm_resource.example.id
  sensitive   = false  # Set to true for sensitive data
}
```

**Output Standards:**
- Always include description
- Mark sensitive outputs appropriately
- Output useful values for module consumers

#### 5. versions.tf

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
```

### Naming Conventions

**Resources:**
- Use descriptive names: `azurerm_virtual_network.vnet`
- Avoid abbreviations unless standard: `nic`, `nsg`, `vm`

**Variables:**
- Use snake_case: `resource_group_name`
- Be descriptive: `enable_public_access` not `pub_access`

**Outputs:**
- Use snake_case
- Be specific: `storage_account_id` not `id`

### Code Style

1. **Formatting:**
   ```bash
   terraform fmt -recursive
   ```

2. **Validation:**
   ```bash
   terraform validate
   ```

3. **Linting (optional):**
   ```bash
   tflint
   ```

### Best Practices

✅ **Do:**
- Use variables for all configurable values
- Provide examples for each module
- Document all variables and outputs
- Use tags consistently
- Implement proper validation
- Use count/for_each for conditional resources
- Follow Azure naming conventions

❌ **Don't:**
- Hardcode values
- Use deprecated features
- Ignore security best practices
- Leave TODO comments in committed code
- Use overly complex logic without comments

## 🧪 Testing

### Manual Testing

1. **Create a test directory:**
   ```bash
   mkdir -p test/my-module
   cd test/my-module
   ```

2. **Create test configuration:**
   ```hcl
   module "test" {
     source = "../../azure/<module-name>"
     
     # Test variables
   }
   ```

3. **Run Terraform commands:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   terraform destroy
   ```

### Test Checklist

- [ ] Module initializes without errors
- [ ] Plan shows expected resources
- [ ] Apply succeeds
- [ ] Resources are created correctly in Azure
- [ ] Outputs return expected values
- [ ] Destroy removes all resources
- [ ] No credentials or secrets in code

## 📝 Pull Request Process

### Before Submitting

1. **Update documentation**
   - README.md
   - Variable descriptions
   - Example usage

2. **Run formatting:**
   ```bash
   terraform fmt -recursive
   ```

3. **Validate:**
   ```bash
   terraform validate
   ```

4. **Test the module** with a real deployment

5. **Update CHANGELOG** (if applicable)

### PR Title Format

Use conventional commits format:

```
<type>(<scope>): <description>

Examples:
feat(vm): add support for Windows VMs
fix(storage): correct container access level
docs(aks): update node pool configuration
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New module
- [ ] Bug fix
- [ ] Feature enhancement
- [ ] Documentation update
- [ ] Breaking change

## Testing
- [ ] Tested with terraform plan
- [ ] Tested with terraform apply
- [ ] All resources created successfully
- [ ] All resources destroyed successfully

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Examples provided/updated
- [ ] Variables have descriptions
- [ ] Outputs have descriptions
- [ ] No hardcoded values
- [ ] No secrets in code

## Screenshots (if applicable)
Add screenshots of terraform plan/apply output
```

### Review Process

1. Automated checks must pass
2. At least one maintainer review required
3. Address all review comments
4. Squash commits if requested
5. Merge to `develop` branch

## 💬 Commit Messages

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Examples

```bash
feat(storage): add lifecycle management support

- Add variables for lifecycle rules
- Update documentation
- Add example configuration

Closes #123
```

```bash
fix(vm): correct NSG association issue

Fixed issue where NSG was not properly associated
with network interface.

Fixes #456
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation
- **style**: Formatting
- **refactor**: Code restructuring
- **test**: Tests
- **chore**: Maintenance

## 🆕 Adding a New Module

1. **Create module directory:**
   ```bash
   mkdir -p azure/<new-module>
   ```

2. **Create required files:**
   - README.md
   - main.tf
   - variables.tf
   - outputs.tf
   - versions.tf

3. **Create example:**
   ```bash
   mkdir -p azure/<new-module>/examples/complete
   touch azure/<new-module>/examples/complete/README.md
   ```

4. **Update root README.md** to include new module

5. **Test thoroughly**

6. **Submit PR** with all documentation

## 📞 Getting Help

- Open an issue with the `question` label
- Reach out to maintainers
- Check existing issues and PRs
- Review module examples

## 🎉 Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes
- Project README (for significant contributions)

Thank you for contributing! 🚀
