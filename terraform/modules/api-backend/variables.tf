variable "region" {
  type = string
}

variable "organization" {
  type = string
}

variable "app_name" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "timezone" {
  type = string
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "app_postgres_password" {
  type      = string
  sensitive = true
}

variable "rails_master_key" {
  type      = string
  sensitive = true
}

variable "s3_region" {
  type      = string
  sensitive = true
}

variable "s3_bucket" {
  type      = string
  sensitive = true
}

variable "s3_access_key" {
  type      = string
  sensitive = true
}

variable "s3_secret_key" {
  type      = string
  sensitive = true
}

variable "s3_signing_key_pair_id" {
  type      = string
  sensitive = true
}

variable "s3_signing_key_pair_private_key" {
  type      = string
  sensitive = true
}

variable "smtp_username" {
  type      = string
  sensitive = true
}

variable "smtp_password" {
  type      = string
  sensitive = true
}

variable "rollbar_access_token" {
  type      = string
  sensitive = true
}