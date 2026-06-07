variable "server_name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "administrator_login" {
  type    = string
  default = "sqladminuser"
}

variable "administrator_password" {
  type      = string
  sensitive = true
}

variable "environment" {
  type = string
}
