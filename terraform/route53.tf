resource "aws_route53_zone" "route53_hosted_zone" {
  name = lookup(var.buckets, "bucket_name")
}

resource "aws_route53_record" "NS_record" {
  allow_overwrite = true
  name            = lookup(var.buckets, "bucket_name")
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.route53_hosted_zone.zone_id

  records = values(var.name_servers)
}