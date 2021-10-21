resource "aws_api_gateway_rest_api" "example" {
  name = "visitor_counter_api"

  disable_execute_api_endpoint = true

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "example" {
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = data.aws_ssm_parameter.path_part.value
  rest_api_id = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_method" "example" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_method" "options" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"
  response_models = {

    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"
  depends_on  = [aws_api_gateway_method.options]

  #passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
  }

  depends_on = [aws_api_gateway_method_response.options_200]
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_method_response.response_200]

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_integration" "example" {
  http_method             = aws_api_gateway_method.example.http_method
  resource_id             = aws_api_gateway_resource.example.id
  rest_api_id             = aws_api_gateway_rest_api.example.id
  type                    = "AWS"
  integration_http_method = "POST"

  uri = "arn:aws:apigateway:${data.aws_ssm_parameter.my_region.value}:${split("https://", split(".", lookup(aws_appsync_graphql_api.appsync_visitor_counter_api.uris, "GRAPHQL"))[0])[1]}.appsync-api:path/graphql"

  credentials = "arn:aws:iam::${data.aws_ssm_parameter.account_id.value}:role/${data.aws_ssm_parameter.appsync_role_name.value}"

  request_parameters = {
    (data.aws_ssm_parameter.custom_header.value) = data.aws_ssm_parameter.custom_value.value
  }

  passthrough_behavior = "WHEN_NO_MATCH"
  #request_templates = {
  #  "application/json" = "{ 'statusCode': 200 }"
  #}
}

output "zcx" {
  value = aws_appsync_graphql_api.appsync_visitor_counter_api.id
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.example.id,
      aws_api_gateway_method.example.id,
      aws_api_gateway_integration.example.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = data.aws_ssm_parameter.appsync_stage_name.value
}

resource "aws_api_gateway_domain_name" "example" {
  regional_certificate_arn = aws_acm_certificate_validation.create_certificate_validation.certificate_arn
  domain_name              = data.aws_ssm_parameter.api_gateway_domain_name.value

  security_policy = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.example.id
  stage_name  = aws_api_gateway_stage.example.stage_name
  domain_name = aws_api_gateway_domain_name.example.domain_name
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

#Create  A record for API Gateway domain record
resource "aws_route53_record" "api_gateway_domain_name_A_record" {
  zone_id = aws_route53_zone.route53_hosted_zone.zone_id
  name    = data.aws_ssm_parameter.api_gateway_domain_name.value

  type = "A"

  alias {
    name                   = aws_api_gateway_domain_name.example.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.example.regional_zone_id
    evaluate_target_health = false
  }
}


resource "aws_iam_role_policy" "appsync_policy" {
  name = "appsync_policy"
  role = aws_iam_role.appsync_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : [
          "appsync:GraphQL"
        ],
        "Resource" : [
          "arn:aws:appsync:${data.aws_ssm_parameter.my_region.value}:${data.aws_ssm_parameter.account_id.value}:apis/${aws_appsync_graphql_api.appsync_visitor_counter_api.id}/*"
        ],
        "Effect" : "Allow"
      }
    ]
    }
  )
}

resource "aws_iam_role" "appsync_role" {
  name = data.aws_ssm_parameter.appsync_role_name.value

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

# change to disable default execution
# Enable CORS correctly (and need to create OPTIONS route) - integration request MOCK, method response 200 and empty, integration response output passthrough YES
# figure out AWS SubDomain
# Enable CloudWatch to AppSync

# api mapping needs path part, need to change on Empty