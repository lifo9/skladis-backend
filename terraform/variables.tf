variable "static_bucket_name" {
  default = "skladis-static"
}

variable "static_bucket_iam_role_name" {
  default = "skladis-s3"
}

variable "static_bucket_iam_policy_name" {
  default = "skladis-s3-rw"
}

variable "skladis_bucket_allowed_user_agent" {
  type      = string
  sensitive = true
}
