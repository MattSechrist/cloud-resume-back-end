# Validate the SSL certificate. DNS took a few hours to validate.
resource "aws_acm_certificate" "create_ssl_certificate" {
  domain_name               = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "bucket_name")
  subject_alternative_names = ["*.${lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "bucket_name")}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "create_certificate_validation" {
  certificate_arn = aws_acm_certificate.create_ssl_certificate.arn
}
