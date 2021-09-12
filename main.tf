terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      vsion = "3.26.0"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "matthewsechrist"

    workspaces {
      name = "cloud_resume_back_end2"
    }
  }
}
# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "www_root_bucket" {
  bucket = "www.matthewsechrist.cloud"
}
