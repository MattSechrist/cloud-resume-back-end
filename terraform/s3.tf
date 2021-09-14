resource "aws_s3_bucket_policy" "www_domain_name" {
  bucket = var.www_domain_name

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "S3_Static_Website_Bucket_Policy"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${var.www_domain_name}/*",
        Condition = {
          StringEquals = {
            "${var.header_name}" : "${var.header_value}"
          }
        }
      },
    ]
  })
}

resource "aws_s3_bucket" "www_domain_name" {
  bucket = var.www_domain_name
  acl    = "public-read"

  website {
    redirect_all_requests_to = var.domain_name
  }
  tags = var.common_tags
}
