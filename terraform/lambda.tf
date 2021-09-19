resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name

  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.lambda_s3_file

  handler = var.lambda_handler
  runtime = var.lambda_runtime

  role = aws_iam_role.lambda_role.arn
}

# IAM role which dictates what other AWS services the Lambda function
# may access.

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "resume-api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  source_arn    = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_rest_api" "VisitorCounterAPI" {
  name        = "VisitorCounterAPI"
  description = "This is my API to get visitor count"
}

resource "aws_api_gateway_resource" "APIResource" {
  rest_api_id = aws_api_gateway_rest_api.VisitorCounterAPI.id
  parent_id   = aws_api_gateway_rest_api.VisitorCounterAPI.root_resource_id
  path_part   = "Get_Visitor_Count"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.VisitorCounterAPI.id
  resource_id   = aws_api_gateway_resource.APIResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}
