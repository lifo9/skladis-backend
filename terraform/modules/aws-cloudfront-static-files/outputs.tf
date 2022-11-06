output "cloudfront_arn" {
  value = aws_cloudfront_distribution.cloudfront.arn
}

output "cloudfront_origin" {
  value = aws_cloudfront_distribution.cloudfront.origin
}
