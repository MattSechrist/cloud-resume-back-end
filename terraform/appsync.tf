resource "aws_appsync_graphql_api" "appsync_visitor_counter_api" {
  authentication_type = "AWS_IAM"
  name                = "appsync_visitor_counter_api"
  identity_pool_config {
      aws_region ="us-east-1"
      default_action = "ALLOW"
      identity_pool_id = "us-east-1:4f5c3e08-f0cc-4b84-b1f8-a6ce99510232"
  }

  schema = <<EOF
type Query {
	visitor_counter: body
}

type body {
	body: String!
}

schema {
	query: Query
}
EOF
}

resource "aws_appsync_api_key" "visitor_counter_api_key" {
  api_id = aws_appsync_graphql_api.appsync_visitor_counter_api.id
}

resource "aws_appsync_datasource" "appsync_visitor_counter_datasource" {
  api_id           = aws_appsync_graphql_api.appsync_visitor_counter_api.id
  name             = "appsync_visitor_counter_datasource"
  service_role_arn = aws_iam_role.lambda_role.arn
  type             = "AWS_LAMBDA"

  lambda_config {
    function_arn = "arn:aws:lambda:us-east-1:${data.aws_ssm_parameter.account_id.value}:function:${data.aws_ssm_parameter.lambda_function_name.value}"
  }
}

resource "aws_appsync_resolver" "aws_appsync_visitor_counter_resolver" {
  api_id      = aws_appsync_graphql_api.appsync_visitor_counter_api.id
  field       = "visitor_counter"
  type        = "Query"
  data_source = aws_appsync_datasource.appsync_visitor_counter_datasource.name

  request_template = <<EOF
{
    "version" : "2017-02-28",
    "operation": "Invoke",
    "payload": $util.toJson($context.arguments)
}
EOF

  response_template = <<EOF
$util.toJson($context.result)
EOF
}