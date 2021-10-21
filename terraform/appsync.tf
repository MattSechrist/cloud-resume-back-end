# This Terraform file builds the lays out the resources needed for the AppSync/GraphQL endpoint.

# Resource for the API which includes: Auth type of API_KEY and the GraphQL schema
resource "aws_appsync_graphql_api" "appsync_visitor_counter_api" {
  authentication_type = "API_KEY"
  name                = "appsync_visitor_counter_api"

  schema = data.aws_ssm_parameter.appsync_schema.value
}

# Resource for the API key
resource "aws_appsync_api_key" "visitor_counter_api_key" {
  api_id = aws_appsync_graphql_api.appsync_visitor_counter_api.id
}

# Resource that builds the datasource that is the Lambda function for the visitor counter
resource "aws_appsync_datasource" "appsync_visitor_counter_datasource" {
  api_id           = aws_appsync_graphql_api.appsync_visitor_counter_api.id
  name             = "appsync_visitor_counter_datasource"
  service_role_arn = aws_iam_role.lambda_role.arn
  type             = "AWS_LAMBDA"

  lambda_config {
    function_arn = "arn:aws:lambda:${data.aws_ssm_parameter.my_region.value}:${data.aws_ssm_parameter.account_id.value}:function:${data.aws_ssm_parameter.lambda_function_name.value}"
  }
}

output "uri" {
  value = split("https://", split(".", lookup(aws_appsync_graphql_api.appsync_visitor_counter_api.uris, "GRAPHQL"))[0])[1]
}


# Utilizes standard template for the Resolver's request and response templates 
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