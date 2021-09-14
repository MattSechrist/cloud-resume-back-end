variable "domain_name" {
  type        = string
  description = "The domain name for the website. (ex. example.com)"
  sensitive   = true
}
variable "www_domain_name" {
  type        = string
  description = "The www.domain name for the website with www prefix . (ex. www.example.com)"
  sensitive   = true
}
variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www, same as domain_name."
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags you want applied to all components, group by Project."
  sensitive   = true
}

variable "header_name" {
  type        = string
  description = "The custom header name for the CloudFront origin."
  sensitive   = true
}

variable "header_value" {
  type        = string
  description = "The custom header value for the CloudFront origin."
  sensitive   = true
}
