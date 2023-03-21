# api 게이트웨이 생성
resource "aws_api_gateway_rest_api" "please" {
  name = "please"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_resource" "auth_resource" {
  parent_id   = aws_api_gateway_rest_api.please.root_resource_id
  path_part   = "auth"
  rest_api_id = aws_api_gateway_rest_api.please.id
}

resource "aws_api_gateway_method" "auth_method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.auth_resource.id
  rest_api_id   = aws_api_gateway_rest_api.please.id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.please.id
  resource_id             = aws_api_gateway_resource.auth_resource.id
  http_method             = aws_api_gateway_method.auth_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.user_auth.invoke_arn
}

resource "aws_api_gateway_integration_response" "auth_integration_response" {
  rest_api_id       = aws_api_gateway_rest_api.please.id
  resource_id       = aws_api_gateway_resource.auth_resource.id
  http_method       = aws_api_gateway_method.auth_method.http_method
  status_code       = "200"
  response_templates = {
    "application/json" = "$input.json('$')"
  }
    depends_on = [aws_api_gateway_integration.integration]
}

resource "aws_api_gateway_method_response" "auth_method_response" {
  rest_api_id = aws_api_gateway_rest_api.please.id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.auth_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}


# Purchase 게이트웨이

resource "aws_api_gateway_resource" "purchase_resource" {
  parent_id   = aws_api_gateway_rest_api.please.root_resource_id
  path_part   = "purchase"
  rest_api_id = aws_api_gateway_rest_api.please.id
}

resource "aws_api_gateway_method" "purchase_method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.purchase_resource.id
  rest_api_id   = aws_api_gateway_rest_api.please.id
}

resource "aws_api_gateway_integration" "integration2" {
  rest_api_id             = aws_api_gateway_rest_api.please.id
  resource_id             = aws_api_gateway_resource.purchase_resource.id
  http_method             = aws_api_gateway_method.purchase_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.user_purchase.invoke_arn
}

resource "aws_api_gateway_integration_response" "purchase_integration_response" {
  rest_api_id       = aws_api_gateway_rest_api.please.id
  resource_id       = aws_api_gateway_resource.purchase_resource.id
  http_method       = aws_api_gateway_method.purchase_method.http_method
  status_code       = "200"
  response_templates = {
    "application/json" = "$input.json('$')"
  }
    depends_on = [aws_api_gateway_integration.integration2]
}

resource "aws_api_gateway_method_response" "purchase_method_response" {
  rest_api_id = aws_api_gateway_rest_api.please.id
  resource_id = aws_api_gateway_resource.purchase_resource.id
  http_method = aws_api_gateway_method.purchase_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.please.id
  stage_description = "test"
  stage_name        = "test"
  depends_on        = [aws_api_gateway_integration_response.auth_integration_response, aws_api_gateway_method_response.auth_method_response, aws_api_gateway_integration_response.purchase_integration_response, aws_api_gateway_method_response.purchase_method_response]
}