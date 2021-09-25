variable "backup_bucket_name" {
  type        = string
  default     = ""
  description = "The name of the backup bucket to copy files to main bucket"
  sensitive   = true
}

variable "s3_website_endpoint" {
  type        = string
  default     = ""
  description = "The S3 Website Endpoint address"
  sensitive   = true
}

variable "cf_origin" {
  type        = string
  default     = ""
  description = "The CloudFront Origin address"
  sensitive   = true
}
variable "http_header" {
  type        = map(string)
  default     = {}
  description = "The custom header name and value for the CloudFront origin."
  sensitive   = true
}

variable "domains" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "A map of the main domain name with and without www prefix"
}

variable "buckets" {
  type    = map(string)
  default = {}
  #sensitive   = true
  description = "A map of the buckets with and without www prefix"
}

variable "lambda_function_name" {
  type        = string
  default     = ""
  description = "The Lambda function name"
  sensitive   = true
}
variable "lambda_s3_file" {
  type        = string
  default     = ""
  description = "The Lambda S3 archive file"
  sensitive   = true
}
variable "lambda_runtime" {
  type        = string
  default     = ""
  description = "The Lambda runtime"
  sensitive   = true
}
variable "lambda_handler" {
  type        = string
  default     = ""
  description = "The Lambda handler"
  sensitive   = true
}
variable "lambda_iam_role" {
  type        = string
  default     = ""
  description = "The Lambda IAM role"
  sensitive   = true
}

variable "lambda_event_type" {
  type        = string
  default     = ""
  description = "The Lambda event type"
  sensitive   = true
}

variable "my_region" {
  type        = string
  default     = ""
  description = "The Lambda event type"
  sensitive   = true
}

variable "account_id" {
  type        = string
  default     = ""
  description = "The Lambda event type"
  sensitive   = true
}

variable "route_key" {
  type        = string
  default     = ""
  description = "The Lambda event type"
  sensitive   = true
}

variable "lambda_function_version" {
  type        = string
  default     = ""
  description = "The Lambda event type"
  sensitive   = true
}

variable "dynamodb_table" {
  type        = string
  default     = ""
  description = "The Lambda event type"
  sensitive   = true
}

variable "table_item" {
  type        = string
  default     = ""
  description = "The Lambda event type"
  sensitive   = true
}