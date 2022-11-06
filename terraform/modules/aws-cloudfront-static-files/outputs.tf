output "cloudfront_arn" {
  value = aws_cloudfront_distribution.cloudfront.arn
}

output "cloudfront_origin" {
  value = aws_cloudfront_distribution.cloudfront.origin
}

output "cloudfront_signing_key_pair_id" {
  value     = aws_cloudfront_public_key.default.id
  sensitive = true
}