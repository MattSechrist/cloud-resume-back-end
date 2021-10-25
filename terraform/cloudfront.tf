# This Terraform file creates all resources needed for the CloudFront distribution

# Creates mandatory OAI resource
resource "aws_cloudfront_origin_access_identity" "create_oai" {
}

# Creates the CloudFront distribution with OAI, HTTP header, and SSL certificate
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = data.aws_ssm_parameter.cf_origin.value
    origin_id                = data.aws_ssm_parameter.cf_origin.value

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.create_oai.cloudfront_access_identity_path
    }

    # Uses a custom header to block direct S3 bucket access
    custom_header {
      name                   = lookup(jsondecode(data.aws_ssm_parameter.http_header.value), "key_no_prefix")
      value                  = lookup(jsondecode(data.aws_ssm_parameter.http_header.value), "value")
    }
  }

  enabled                    = true
  is_ipv6_enabled            = true
  default_root_object        = "index.html"

  aliases                    = values(jsondecode(data.aws_ssm_parameter.buckets.value))

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = data.aws_ssm_parameter.cf_origin.value

    forwarded_values {
      query_string           = false

      cookies {
        forward              = "none"
      }
    }

    min_ttl                  = 0
    default_ttl              = 86400
    max_ttl                  = 31536000
    compress                 = true
    viewer_protocol_policy   = "redirect-to-https"

    # This adds the security headers to the origin response
    lambda_function_association {
      event_type             = "origin-response"

      lambda_arn             = aws_lambda_function.SecurityHeaders_lambda_function.qualified_arn
    }

  }

  restrictions {
    geo_restriction {
      restriction_type       = "none"
    }


  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.create_ssl_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # For all Forbidden messages, send a 404 response and get the error.html returned to user
  custom_error_response {
    error_caching_min_ttl    = "10"
    error_code               = "403"
    response_code            = "404"
    response_page_path       = "/error.html"
  }
}