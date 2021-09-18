variable "backup_bucket_name" {
  type        = string
  description = "The name of the backup bucket to copy files to main bucket"
  #sensitive   = true
}

variable "s3_website_endpoint" {
  type        = string
  description = "The S3 Website Endpoint address"
  #sensitive   = true
}

variable "cf_origin" {
  type        = string
  description = "The CloudFront Origin address"
  #sensitive   = true
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

variable "lambda_function_name" {
  type        = map(string)
  description = "The Lambda function name"
  sensitive   = true
}
variable "lambda_s3_bucket" {
  type        = map(string)
  description = "The Lambda S3 bucket"
  sensitive   = true
}
variable "lambda_s3_file" {
  type        = map(string)
  description = "The Lambda S3 archive file"
  sensitive   = true
}
variable "lambda_runtime" {
  type        = map(string)
  description = "The Lambda runtime"
  sensitive   = true
}
variable "lambda_handler" {
  type        = map(string)
  description = "The Lambda handler"
  sensitive   = true
}
variable "lambda_iam_role" {
  type        = map(string)
  description = "The Lambda IAM role"
  sensitive   = true
}    