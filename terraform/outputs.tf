output "skladis_static_bucket_bucket_name" {
  value = aws_s3_bucket.skladis_static_bucket.bucket
}

output "skladis_static_bucket_arn" {
  value = aws_s3_bucket.skladis_static_bucket.arn
}

output "skladis_static_bucket_endpoint" {
  value = aws_s3_bucket.skladis_static_bucket.bucket_regional_domain_name
}

output "skladis_static_iam_access_key" {
  value     = aws_iam_access_key.static_files_bucket_iam.id
  sensitive = true
}

output "skladis_static_iam_secret_key" {
  value     = aws_iam_access_key.static_files_bucket_iam.secret
  sensitive = true
}
