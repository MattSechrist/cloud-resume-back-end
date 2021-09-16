# Create SSL Certificate - Used Email over DNS validation as it is a faster setup method, however it is not a Terraform first approach
resource "aws_acm_certificate" "create_ssl_certificate" {
  domain_name               = lookup(var.buckets, "bucket_name")
  subject_alternative_names = ["*.${lookup(var.buckets, "bucket_name")}"]
  validation_method         = "EMAIL"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "create_certificate_validation" {
  certificate_arn = var.ssl_cert_arn
}
