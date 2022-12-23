# S3 bucket for static files
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

# disallow public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# create IAM role for Rails backend
resource "aws_iam_user" "s3_bucket_iam" {
  name = var.bucket_iam_role_name
  path = "/skladis/"
}

resource "aws_iam_access_key" "s3_bucket_iam" {
  user = aws_iam_user.s3_bucket_iam.name
}

resource "aws_iam_user_policy" "default" {
  name = var.bucket_iam_policy_name
  user = aws_iam_user.s3_bucket_iam.name

  policy = templatefile("${path.module}/static_files_bucket_iam.json.tmpl", {
    s3_bucket_arn = aws_s3_bucket.s3_bucket.arn
  })
}