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

provider "aws" {
  alias  = "global"
  region = "us-east-1"
}

resource "aws_cloudfront_origin_access_control" "cloudfront" {
  name                              = "${var.domain_name}_oac"
  description                       = "OAC for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Bucket Policy
resource "aws_s3_bucket_policy" "bucket_cloudfront_policy" {
  bucket = var.bucket_id
  policy = templatefile("${path.module}/cloudfront_bucket_policy.json.tmpl", {
    cloudfront_arn = aws_cloudfront_distribution.cloudfront.arn
    s3_bucket_arn  = var.bucket_arn
  })
}

# Key group
resource "aws_cloudfront_key_group" "default" {
  items = [
    aws_cloudfront_public_key.default.id
  ]
  name = "skladis-signing-keys"
}

resource "aws_cloudfront_public_key" "default" {
  name        = "skladis-key"
  encoded_key = file("${path.module}/signing_key.pub")

  lifecycle {
    ignore_changes = [encoded_key]
  }
}

# CloudFront distribution
locals {
  s3_origin_id = "${var.domain_name}_origin"
}
resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  aliases             = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    trusted_key_groups = [
      aws_cloudfront_key_group.default.id
    ]

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# DNS records
data "cloudflare_zones" "domain" {
  filter {
    name = var.zone_name
  }
}

resource "cloudflare_record" "main_dns" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = var.domain_name
  value   = aws_cloudfront_distribution.cloudfront.domain_name
  type    = "CNAME"
  proxied = true
}

resource "aws_acm_certificate" "certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  provider          = aws.global
}

resource "cloudflare_record" "verification_dns" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = each.value.name
  value   = each.value.record
  type    = each.value.type
  proxied = false

  lifecycle {
    ignore_changes = [value]
  }
}

# This resource represents a successful validation of an ACM certificate in concert with other resources.
resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in cloudflare_record.verification_dns : record.hostname]
  provider                = aws.global
}