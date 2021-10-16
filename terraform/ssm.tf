# This Terraform file sets all the Terraform variables to their associated values pulled from the AWS Parameter Store 
data "aws_ssm_parameter" "dynamodb_table" {
  name = "dynamodb_table"
}

data "aws_ssm_parameter" "domains" {
  name = "domains"
}

data "aws_ssm_parameter" "buckets" {
  name = "buckets"
}

data "aws_ssm_parameter" "cf_origin" {
  name = "cf_origin"
}
data "aws_ssm_parameter" "s3_website_endpoint" {
  name = "s3_website_endpoint"
}

data "aws_ssm_parameter" "backup_bucket_name" {
  name = "backup_bucket_name"
}

data "aws_ssm_parameter" "http_header" {
  name = "http_header"
}

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

data "aws_ssm_parameter" "kms_key" {
  name = "kms_key"
}
