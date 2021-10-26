# This Terraform file creates the S3 bucket policy to only allow GetObject to CloudFront using the OAI, along
# with setting the HTTP header condition

# Creates the S3 bucket policy
resource "aws_s3_bucket_policy" "public_bucket_policy" {

  # To use sensitive variables in a for_each, that must be marked nonsensitive since value
  # must be known 
  for_each         = nonsensitive(jsondecode(data.aws_ssm_parameter.buckets.value))
 
  bucket           = each.value

  # This policy inclues the custom header to stop direct S# bucket access from a browser without it
  policy           = jsonencode({
    Version        = "2012-10-17"
    Id             = "S3_Static_Website_Bucket_Policy"
    Statement      = [
      { 
        Effect     = "Allow"
        Principal  = { "AWS" : "${aws_cloudfront_origin_access_identity.create_oai.iam_arn}" },
        Action     = "s3:GetObject",
        Resource   = "arn:aws:s3:::${each.value}/*",
        Condition  = {
          StringEquals = {
            "${lookup(jsondecode(data.aws_ssm_parameter.http_header.value), "key")}" : "${lookup(jsondecode(data.aws_ssm_parameter.http_header.value), "value")}"
          }
        }
      },
    ]
  })
}

# Creates a second bucket for the www domain name with redirect to the primary bucket with the non-www domain name
# This bucket is empty and only does the redirection
resource "aws_s3_bucket" "create_www_domain_bucket" {
  bucket            = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "www_bucket_name")
  acl               = "public-read"
  lifecycle {
    prevent_destroy = true
  }

  website {
    redirect_all_requests_to = lookup(jsondecode(data.aws_ssm_parameter.domains.value), "domain_name")
  }
}

# Creates the domain bucket for the website, including CORS
resource "aws_s3_bucket" "create_domain_bucket" {
  bucket            = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "bucket_name")
  acl               = "public-read"
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = [lookup(jsondecode(data.aws_ssm_parameter.domains.value), "domain_name")]
    max_age_seconds = 300
  }

  website {
    index_document  = "index.html"
    error_document  = "error.html"
  }
}
