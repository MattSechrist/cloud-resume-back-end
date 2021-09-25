#Create Lambda function 
resource "aws_lambda_function" "lambda_function" {
  function_name = data.aws_ssm_parameter.lambda_function_name.value

  s3_bucket = data.aws_ssm_parameter.backup_bucket_name.value
  s3_key    = data.aws_ssm_parameter.lambda_s3_file.value

  handler = data.aws_ssm_parameter.lambda_handler.value
  runtime = data.aws_ssm_parameter.lambda_runtime.value

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

#Create the HTTP API 
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

#Lambda itegrtion requires the type of AWS_PROXY and a method of POST
resource "aws_apigatewayv2_integration" "CloudResumeAPI" {
  api_id = aws_apigatewayv2_api.CloudResumeAPI.id

  integration_uri    = aws_lambda_function.lambda_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

#Setting up the API Gatewat route
resource "aws_apigatewayv2_route" "CloudResumeAPI" {
  api_id = aws_apigatewayv2_api.CloudResumeAPI.id

  route_key = data.aws_ssm_parameter.route_key.value
  target    = "integrations/${aws_apigatewayv2_integration.CloudResumeAPI.id}"

}

#Attaching the Lambda action to the API Gateway
resource "aws_lambda_permission" "CloudResumeAPI" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.CloudResumeAPI.execution_arn}/*/*"
}