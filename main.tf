terraform {
  required_version = "~> 1.0.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }  
  
  backend "remote" {
    organization = "matthewsechrist"

    workspaces {
      name = "cloud_resume_back_end"
    }
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "mss444lskfjsdlkj"
  acl    = "private"
}
