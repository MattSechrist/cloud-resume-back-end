#resource "aws_ssm_parameter" "buckets" {
#  name        = "buckets"
#  description = "Buckets"
#  type        = "SecureString"
#  key_id      = "alias/KMSKey"
#  value       = jsonencode(var.buckets)
#}
#
#
#resource "aws_ssm_parameter" "domains" {
#  name        = "domains"
#  description = "Domains"
#  type        = "SecureString"
#  key_id      = "alias/KMSKey"
#  value       = jsonencode(var.domains)
#}
#
#resource "aws_ssm_parameter" "http_header" {
#  name        = "http_header"
#  description = "http_header"
#  type        = "SecureString"
#  key_id      = "alias/KMSKey"
#  value       = jsonencode(var.http_header)
#}

#Set the dynamodb table variable. The columns, rows and data are handled in Lambda.
data "aws_ssm_parameter" "dynamodb_table" {
  name = "dynamodb_table"
}

#Set the www and non-www domain variable
data "aws_ssm_parameter" "domains" {
  name = "domains"
}

#Set the www and non-www bucket name variables
data "aws_ssm_parameter" "buckets" {
  name = "buckets"
}

#Set the cf_origin and s3_website_endpoint variables for CloudFront
data "aws_ssm_parameter" "cf_origin" {
  name = "cf_origin"
}
data "aws_ssm_parameter" "s3_website_endpoint" {
  name = "s3_website_endpoint"
}

#Set the variables used for backup S3 bucket to copy to domain buckets
data "aws_ssm_parameter" "backup_bucket_name" {
  name = "backup_bucket_name"
}

#Set the HTTP Header to block direct S3 bucket access
data "aws_ssm_parameter" "http_header" {
  name = "http_header"
}

#Set the Lambda variables for our function that gets the visitor counter
data "aws_ssm_parameter" "lambda_function_name" {
  name = "lambda_function_name"
}
data "aws_ssm_parameter" "lambda_s3_file" {
  name = "lambda_s3_file"
}
data "aws_ssm_parameter" "lambda_runtime" {
  name = "lambda_runtime"
}
data "aws_ssm_parameter" "lambda_handler" {
  name = "lambda_handler"
}
data "aws_ssm_parameter" "lambda_iam_role" {
  name = "lambda_iam_role"
}
data "aws_ssm_parameter" "lambda_event_type" {
  name = "lambda_event_type"
}
data "aws_ssm_parameter" "route_key" {
  name = "route_key"
}
data "aws_ssm_parameter" "lambda_function_version" {
  name = "lambda_function_version"
}

#Set AWS global and regional variables
data "aws_ssm_parameter" "my_region" {
  name = "my_region"
}
data "aws_ssm_parameter" "account_id" {
  name = "account_id"
}

data "aws_ssm_parameter" "dynamodb_hash_key" {
  name = "dynamodb_hash_key"
}

data "aws_ssm_parameter" "dynamodb_hash_key_value" {
  name = "dynamodb_hash_key_value"
}
data "aws_ssm_parameter" "dynamodb_table_column" {
  name = "dynamodb_table_column"
}
data "aws_ssm_parameter" "table_item" {
  name = "table_item"
}
