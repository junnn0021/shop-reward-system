# resource "aws_api_gateway_rest_api" "user" {
#   name = "user_j"
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_resource" "auth" {
#   rest_api_id = aws_api_gateway_rest_api.user.id
#   parent_id   = aws_api_gateway_rest_api.user.root_resource_id
#   path_part   = "auth"
# }

# resource "aws_api_gateway_method" "auth" {
#   rest_api_id   = aws_api_gateway_rest_api.user.id
#   resource_id   = aws_api_gateway_resource.auth.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "auth" {
#   rest_api_id          = aws_api_gateway_rest_api.user.id
#   resource_id          = aws_api_gateway_resource.auth.id
#   http_method          = aws_api_gateway_method.auth.http_method
#   integration_http_method = "POST"
#   type                 = "AWS"
#   uri                  = aws_lambda_function.user_auth.invoke_arn
# }

# resource "aws_api_gateway_method_response" "authsoobin_auth_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.user.id
#   resource_id = aws_api_gateway_resource.auth.id
#   http_method = aws_api_gateway_method.auth.http_method
#   status_code = "200"

#   response_models = {
#     "application/json" = null
#   }
# }

# resource "aws_api_gateway_resource" "purchase" {
#   rest_api_id = aws_api_gateway_rest_api.user.id
#   parent_id   = aws_api_gateway_rest_api.user.root_resource_id
#   path_part   = "purchase"
# }

# resource "aws_api_gateway_method" "purchase" {
#   rest_api_id   = aws_api_gateway_rest_api.user.id
#   resource_id   = aws_api_gateway_resource.purchase.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "purchase" {
#   rest_api_id          = aws_api_gateway_rest_api.user.id
#   resource_id          = aws_api_gateway_resource.purchase.id
#   http_method          = aws_api_gateway_method.purchase.http_method
#   integration_http_method = "POST"
#   type                 = "AWS"
#   uri                  = aws_lambda_function.user_purchase.invoke_arn
# }

# resource "aws_api_gateway_method_response" "authsoobin_purchase_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.user.id
#   resource_id = aws_api_gateway_resource.purchase.id
#   http_method = aws_api_gateway_method.purchase.http_method
#   status_code = "200"

#   response_models = {
#     "application/json" = null
#   }
# }

# resource "aws_lambda_permission" "apigw_auth" {
# statement_id  = "AllowExecutionFromAPIGateway1"
# action        = "lambda:InvokeFunction"
# function_name = aws_lambda_function.user_auth.function_name

# principal     = "apigateway.amazonaws.com"
# source_arn    = "${aws_api_gateway_rest_api.user.execution_arn}/*/*${aws_api_gateway_resource.auth.path}"
# }

# resource "aws_lambda_permission" "apigw_purchase" {
#   statement_id  = "AllowExecutionFromAPIGateway2"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.user_purchase.function_name

#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.user.execution_arn}/*/*${aws_api_gateway_resource.purchase.path}"
# }

# resource "aws_api_gateway_deployment" "example" {
#   depends_on = [
#     aws_api_gateway_integration.auth,
#     aws_api_gateway_integration.purchase,
#   ]
#   rest_api_id = aws_api_gateway_rest_api.user.id
#   stage_name  = "default"
# }

resource "aws_api_gateway_rest_api" "example" {
  name = "example"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "example" {
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "auth"
  rest_api_id = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_method" "example" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.example.id
  http_method             = aws_api_gateway_method.example.http_method
  integration_http_method = "ANY"
  type                    = "AWS"
  uri                     = aws_lambda_function.user_auth.invoke_arn
}

resource "aws_api_gateway_integration_response" "auth_integration_response" {
  rest_api_id       = aws_api_gateway_rest_api.example.id
  resource_id       = aws_api_gateway_resource.example.id
  http_method       = aws_api_gateway_method.example.http_method
  status_code       = "200"
  response_templates = {
    "application/json" = "$input.json('$')"
  }
    depends_on = [aws_api_gateway_integration.integration]
}

resource "aws_api_gateway_method_response" "auth_method_response" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_description = "test"
  stage_name        = "test"
  depends_on        = [aws_api_gateway_integration_response.auth_integration_response, aws_api_gateway_method_response.auth_method_response]
}