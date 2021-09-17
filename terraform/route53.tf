resource "aws_route53_zone" "route53_hosted_zone" {
  name = lookup(var.buckets, "bucket_name")
}

resource "aws_route53_record" "NS_record" {
  allow_overwrite = true
  name            = lookup(var.buckets, "bucket_name")
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.route53_hosted_zone.zone_id

  records = aws_route53_zone.route53_hosted_zone.name_servers
}

resource "aws_route53_record" "A_record" {
  zone_id = aws_route53_zone.route53_hosted_zone.zone_id
  name    = lookup(var.buckets, "bucket_name")
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "A_www_record" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.route53_hosted_zone.zone_id
  name            = lookup(var.buckets, "www_bucket_name")
  type            = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
