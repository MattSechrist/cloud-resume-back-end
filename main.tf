terraform {
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
