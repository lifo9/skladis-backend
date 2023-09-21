terraform {
  backend "s3" {
    bucket = "terraform-filo-state-bucket"
    key    = "skladis/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-filo-state-locks"
    encrypt        = true
  }
}

module "s3_bucket" {
  source = "./modules/aws-s3-static-files-bucket"

  aws_region             = var.aws_region
  bucket_name            = var.static_bucket_name
  bucket_iam_role_name   = var.static_bucket_iam_role_name
  bucket_iam_policy_name = var.static_bucket_iam_policy_name
}

module "cloudfront_static_files" {
  source = "./modules/aws-cloudfront-static-files"

  aws_region                  = var.aws_region
  bucket_id                   = module.s3_bucket.bucket_id
  bucket_arn                  = module.s3_bucket.bucket_arn
  bucket_regional_domain_name = module.s3_bucket.bucket_regional_domain_name
  zone_name                   = var.zone_name
  domain_name                 = var.static_domain_name
}

module "api_backend" {
  source = "./modules/api-backend"

  app_name                        = var.api_app_name
  zone_name                       = var.zone_name
  domain_name                     = var.api_domain_name
  organization                    = var.api_org_name
  region                          = var.api_region
  postgres_password               = var.api_postgres_password
  app_postgres_password           = var.api_app_postgres_password
  timezone                        = var.api_timezone
  rails_master_key                = var.api_rails_master_key
  s3_region                       = module.s3_bucket.bucket_region
  s3_bucket                       = var.static_bucket_name
  s3_access_key                   = module.s3_bucket.bucket_iam_access_key
  s3_secret_key                   = module.s3_bucket.bucket_iam_secret_key
  s3_signing_key_pair_id          = module.cloudfront_static_files.cloudfront_signing_key_pair_id
  s3_signing_key_pair_private_key = var.s3_signing_key_pair_private_key
  smtp_username                   = var.api_smtp_username
  smtp_password                   = var.api_smtp_password
  rollbar_access_token            = var.api_rollbar_access_token
}