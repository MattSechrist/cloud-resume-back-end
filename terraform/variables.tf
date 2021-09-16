variable "backup_bucket_name" {
  type        = string
  description = "The name of the backup bucket to copy files to main bucket"
  sensitive   = true
}

variable "ssl_cert_arn" {
  type        = string
  description = "The SSL Certificate ARN"
  sensitive   = true
}

variable "oai" {
  type        = string
  description = "The Origin Access Identity"
  sensitive   = true
}

variable "name_servers" {
  type        = map(string)
  description = "The Route53 Name Servers"
  sensitive   = true
}
variable "s3_website_endpoint" {
  type        = string
  description = "The S3 Website Endpoint address"
  sensitive   = true
}
variable "http_header" {
  type        = map(string)
  description = "The custom header name and value for the CloudFront origin."
  sensitive   = true
}
variable "website_files" {
  type        = map(string)
  default     = {}
  description = "A map of all website file names with folder structure locations"
}

variable "domains" {
  type        = map(string)
  description = "A map of the main domain name with and without www prefix"
}

variable "buckets" {
  type        = map(string)
  description = "A map of the buckets with and without www prefix"
}