terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "matthewsechrist"

    workspaces {
      name = "cloud_resume_back_end"
    }
  }
}
# S3 bucket for website.
#esource "aws_s3_bucket" "www_bucket" {
# bucket = "www.${var.bucket_name}2"
# acl    = "public-read"
# policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
#
# cors_rule {
#   allowed_headers = ["Authorization", "Content-Length"]
#   allowed_methods = ["GET", "POST"]
#   allowed_origins = ["https://www.${var.domain_name}"]
#   max_age_seconds = 3000
# }
#
# website {
#   index_document = "index.html"
#   error_document = "404.html"
# }
#
# tags = var.common_tags
#
#
# S3 bucket for redirecting non-www to www.
#esource "aws_s3_bucket" "root_bucket" {
# bucket = var.bucket_name
# acl    = "public-read"
# policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })
#
# website {
#   redirect_all_requests_to = "https://www.${var.domain_name}"
# }
#
# tags = var.common_tags
#
# S3 bucket for website.
#esource "aws_s3_bucket" "www_bucket" {
# bucket = "www.${var.bucket_name}"
# acl    = "public-read"
# policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
#
# cors_rule {
#   allowed_headers = ["Authorization", "Content-Length"]
#   allowed_methods = ["GET", "POST"]
#   allowed_origins = ["https://www.${var.domain_name}"]
#   max_age_seconds = 3000
# }
#
# website {
#   index_document = "index.html"
#   error_document = "404.html"
# }
#
# tags = var.common_tags
#

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "www_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = "templates/s3-policy.json"

  website {
    redirect_all_requests_to = format("%s%s","https://",var.domain_name)
  }
  tags = var.common_tags
}
