variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}
variable "www_domain_name" {
  type        = string
  description = "The www.domain name for the website."
}
variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
}

variable "header_name" {
  description = "The custom header name for the CloudFront origin."
  sensitive = true
}

variable "header_value" {
  description = "The custom header value for the CloudFront origin."
  sensitive = true
}