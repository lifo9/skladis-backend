output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

output "bucket_endpoint" {
  value = module.s3_bucket.bucket_endpoint
}

output "bucket_iam_access_key" {
  value     = module.s3_bucket.bucket_iam_access_key
  sensitive = true
}

output "bucket_iam_secret_key" {
  value     = module.s3_bucket.bucket_iam_secret_key
  sensitive = true
}
