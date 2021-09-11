terraform {
  backend "remote" {
    organization = "matthewsechrist"

    workspaces {
      name = "cloud_resume_back_end"
    }
  }
}

resource "aws_s3_bucket" "bucket" {
   bucket = "mss_test_bucket_sfdlkjfalskfjsdlkj"
  acl    = "private"
}
