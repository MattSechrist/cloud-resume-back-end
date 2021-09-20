resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name

  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.lambda_s3_file

  handler = var.lambda_handler
  runtime = var.lambda_runtime

  role    = aws_iam_role.lambda_role.arn
  publish = true
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

resource "aws_lambda_alias" "lambda_alias" {
  name             = "lambda_alias"
  description      = "a sample description"
  function_name    = aws_lambda_function.lambda_function.arn
  function_version = var.lambda_function_version
}

resource "aws_apigatewayv2_api" "CloudResumeAPI" {
  name          = "CloudResumeAPI"
  protocol_type = "HTTP"
  target        = aws_lambda_function.lambda_function.arn
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "GET", "OPTIONS"]
    allow_headers = ["content-type"]
    max_age       = 300
  }
}


resource "aws_apigatewayv2_integration" "CloudResumeAPI" {
  api_id = aws_apigatewayv2_api.CloudResumeAPI.id

  integration_uri    = aws_lambda_function.lambda_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "CloudResumeAPI" {
  api_id = aws_apigatewayv2_api.CloudResumeAPI.id

  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.CloudResumeAPI.id}"

}



resource "aws_lambda_permission" "CloudResumeAPI" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.CloudResumeAPI.execution_arn}/*/*"
}
