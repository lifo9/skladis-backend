# General
variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "zone_name" {
  type    = string
  default = "skladis.com"
}

# Static files
variable "static_bucket_name" {
  type    = string
  default = "skladis-static"
}

variable "static_bucket_iam_role_name" {
  type    = string
  default = "skladis-s3"
}

variable "static_bucket_iam_policy_name" {
  type    = string
  default = "skladis-s3-rw"
}

variable "static_domain_name" {
  type    = string
  default = "static.skladis.com"
}

# API Backend
variable "api_org_name" {
  type    = string
  default = "skladis-675"
}

variable "api_app_name" {
  type    = string
  default = "skladis-api"
}

variable "api_region" {
  type    = string
  default = "fra" # Frankfurt
}

variable "api_timezone" {
  type    = string
  default = "Europe/Bratislava"
}

variable "api_domain_name" {
  type    = string
  default = "api.skladis.com"
}

variable "api_postgres_password" {
  type      = string
  sensitive = true
}

variable "api_app_postgres_password" {
  type      = string
  sensitive = true
}

variable "api_rails_master_key" {
  type      = string
  sensitive = true
}

variable "s3_signing_key_pair_private_key" {
  type      = string
  sensitive = true
}

variable "api_smtp_username" {
  type      = string
  sensitive = true
}

variable "api_smtp_password" {
  type      = string
  sensitive = true
}