terraform {
  backend "s3" {
    bucket = "terraform-filo-state-bucket"
    key    = "skladis/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-filo-state-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "s3_bucket" {
  source = "./modules/aws-s3-static-files-bucket"

  bucket_name            = "skladis-static"
  bucket_iam_role_name   = "skladis-s3"
  bucket_iam_policy_name = "skladis-s3-rw"
}

module "cloudfront_static_files" {
  source = "./modules/aws-cloudfront-static-files"

  bucket_id                   = module.s3_bucket.bucket_id
  bucket_arn                  = module.s3_bucket.bucket_arn
  bucket_regional_domain_name = module.s3_bucket.bucket_regional_domain_name
  zone_name                   = "skladis.com"
  domain_name                 = "static.skladis.com"
}