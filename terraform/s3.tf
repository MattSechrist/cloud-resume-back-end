resource "aws_s3_bucket_policy" "public_bucket_policy" {

  for_each = var.buckets

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
            "${var.http_header.key}" : "${var.http_header.value}"
          }
        }
      },
    ]
  })
}

resource "aws_s3_bucket" "create_www_domain_bucket" {
  bucket = lookup(var.buckets, "www_bucket_name")
  acl    = "public-read"
  lifecycle {
    prevent_destroy = true
  }

  website {
    redirect_all_requests_to = lookup(var.domains, "domain_name")
  }
}
resource "aws_s3_object_copy" "website_files" {

  for_each = var.website_files

  bucket = lookup(var.buckets, "bucket_name")
  key    = each.key
  source = each.value
}

# S3 bucket for website.
resource "aws_s3_bucket" "create_domain_bucket" {
  bucket = lookup(var.buckets, "bucket_name")
  acl    = "public-read"
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = [lookup(var.domains, "domain_name")]
    max_age_seconds = 300
  }

  website {
    index_document = "index.html"
  }
}