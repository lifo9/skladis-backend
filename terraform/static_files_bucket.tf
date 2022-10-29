# S3 bucket for static files
resource "aws_s3_bucket" "skladis_static_bucket" {
  bucket = var.static_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

# disallow public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.skladis_static_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.skladis_static_bucket.id
  policy = templatefile("static_files_bucket_policy.json.tmpl", {
    s3_bucket_arn = aws_s3_bucket.skladis_static_bucket.arn,
    user_agent    = var.skladis_bucket_allowed_user_agent
  })
}
