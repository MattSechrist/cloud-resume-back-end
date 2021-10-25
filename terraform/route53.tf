# This Terraform file creates the Route 53 Hosted Zone and all DNS records

# Creates the hosted zone
resource "aws_route53_zone" "route53_hosted_zone" {
  name                     = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "bucket_name")
}

# Create mandatory NS records with four given Name server records
resource "aws_route53_record" "NS_record" {
  allow_overwrite          = true
  name                     = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "bucket_name")
  ttl                      = 172800
  type                     = "NS"
  zone_id                  = aws_route53_zone.route53_hosted_zone.zone_id
         
  records                  = aws_route53_zone.route53_hosted_zone.name_servers
}

#Create mandatory A record for IPv4 name resolution of non-www domain name
resource "aws_route53_record" "A_record" {
  zone_id = aws_route53_zone.route53_hosted_zone.zone_id
  name    = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "bucket_name")
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

#Create secondary A record for IPv4 name resolution of www domain name
resource "aws_route53_record" "A_www_record" {
  allow_overwrite          = true
  zone_id                  = aws_route53_zone.route53_hosted_zone.zone_id
  name                     = lookup(jsondecode(data.aws_ssm_parameter.buckets.value), "www_bucket_name")
  type                     = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

#Create  A record for API Gateway domain record
resource "aws_route53_record" "visitor_counter_A_record" {
  zone_id                  = aws_route53_zone.route53_hosted_zone.zone_id
  name                     = data.aws_ssm_parameter.api_gateway_domain_name.value

  type                     = "A"

  alias {
    name                   = aws_api_gateway_domain_name.visitor_counter_domain_name.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.visitor_counter_domain_name.regional_zone_id
    evaluate_target_health = false
  }
}
