terraform {
  backend "s3" {
    bucket = "terraform-filo-state-bucket"
    key    = "skladis/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-filo-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "s3_bucket" {
  source = "./modules/aws-s3-static-files-bucket"

  bucket_name               = "skladis-static"
  bucket_allowed_user_agent = var.s3_bucket_allowed_user_agent
  bucket_iam_role_name      = "skladis-s3"
  bucket_iam_policy_name    = "skladis-s3-rw"
}