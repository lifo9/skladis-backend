output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

output "bucket_regional_domain_name" {
  value = module.s3_bucket.bucket_regional_domain_name
}

output "bucket_iam_access_key" {
  value     = module.s3_bucket.bucket_iam_access_key
  sensitive = true
}

output "bucket_iam_secret_key" {
  value     = module.s3_bucket.bucket_iam_secret_key
  sensitive = true
}
