# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier

  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  allow_nested_items_to_be_public = var.enable_public_access

  blob_properties {
    delete_retention_policy {
      days = var.enable_blob_soft_delete ? var.blob_soft_delete_retention_days : null
    }

    container_delete_retention_policy {
      days = var.enable_container_soft_delete ? var.container_soft_delete_retention_days : null
    }

    versioning_enabled  = var.enable_versioning
    change_feed_enabled = var.enable_change_feed
  }

  tags = var.tags
}

# Network Rules (if IP ranges or subnets are specified)
resource "azurerm_storage_account_network_rules" "network_rules" {
  count = length(var.allowed_ip_ranges) > 0 || length(var.allowed_subnet_ids) > 0 ? 1 : 0

  storage_account_id = azurerm_storage_account.storage.id

  default_action             = "Deny"
  ip_rules                   = var.allowed_ip_ranges
  virtual_network_subnet_ids = var.allowed_subnet_ids
  bypass                     = ["AzureServices"]
}

# Blob Containers
resource "azurerm_storage_container" "containers" {
  for_each = { for container in var.containers : container.name => container }

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = each.value.access_type
}
