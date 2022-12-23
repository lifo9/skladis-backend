output "bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "bucket_region" {
  value = aws_s3_bucket.s3_bucket.region
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "bucket_iam_access_key" {
  value     = aws_iam_access_key.s3_bucket_iam.id
  sensitive = true
}

output "bucket_iam_secret_key" {
  value     = aws_iam_access_key.s3_bucket_iam.secret
  sensitive = true
}
