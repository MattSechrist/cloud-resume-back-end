#Create S3 bucket policy to only allow GetObject to CloudFront using the OAI, along
#with setting the HTTP header condition
resource "aws_s3_bucket_policy" "public_bucket_policy" {

#you can create a value to pass to for_each with toset([for k,v in local.map : k])
  for_each = nonsensitive(jsondecode(data.aws_ssm_parameter.buckets.value))

  bucket = each.value

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "S3_Static_Website_Bucket_Policy"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { "AWS" : "${aws_cloudfront_origin_access_identity.create_oai.iam_arn}" },
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${each.value}/*",
        Condition = {
          StringEquals = {
            "${lookup(jsondecode(data.aws_ssm_parameter.http_header.value), "key")}" : "${lookup(jsondecode(data.aws_ssm_parameter.http_header.value), "value")}"
          }
        }
      },
    ]
  })
}

#Create www domain with redirect to non-www domain
resource "aws_s3_bucket" "create_www_domain_bucket" {
  bucket = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "www_bucket_name")
  acl    = "public-read"
  lifecycle {
    prevent_destroy = true
  }

  website {
    redirect_all_requests_to = lookup(jsondecode(data.aws_ssm_parameter.domains.value), "domain_name")
  }
}

#Create domain bucket for the website, including CORS
resource "aws_s3_bucket" "create_domain_bucket" {
  bucket = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "bucket_name")
  acl    = "public-read"
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = [lookup(jsondecode(data.aws_ssm_parameter.domains.value), "domain_name")]
    max_age_seconds = 300
  }

  website {
    index_document = "index.html"
  }
}
