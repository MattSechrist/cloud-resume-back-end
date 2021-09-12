terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
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
# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "www_root_bucket" {
  bucket = "www.matthewsechrist.cloud"

    redirect_all_requests_to = "https://matthewsechrist.cloud"
  }