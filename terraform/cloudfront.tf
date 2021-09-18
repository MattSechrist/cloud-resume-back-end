resource "aws_cloudfront_origin_access_identity" "create_oai" {
}

output "oai" {
  value = aws_cloudfront_origin_access_identity.create_oai.cloudfront_access_identity_path
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.cf_origin
    origin_id   = var.cf_origin

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.create_oai.cloudfront_access_identity_path
    }
    custom_header {
      name  = var.http_header.key_no_prefix
      value = var.http_header.value
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = values(var.buckets)

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.cf_origin

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.create_ssl_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}