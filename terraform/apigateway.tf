resource "aws_apigatewayv2_api" "weather" {
  name          = "${var.resource_prefix}weather"
  protocol_type = "HTTP"
  disable_execute_api_endpoint = true

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_domain_name" "weather" {
  domain_name = local.domain

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.weather.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.weather.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api_mapping" "weather" {
  api_id      = aws_apigatewayv2_api.weather.id
  domain_name = aws_apigatewayv2_domain_name.weather.id
  stage       = aws_apigatewayv2_stage.default.id
}

resource "aws_apigatewayv2_integration" "get_weather" {
  api_id                 = aws_apigatewayv2_api.weather.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.get_weather.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "update_weather" {
  api_id                 = aws_apigatewayv2_api.weather.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.update_weather.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "weather_authorizer" {
  api_id                 = aws_apigatewayv2_api.weather.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.weather_authorizer.invoke_arn
}

resource "aws_apigatewayv2_route" "get_weather" {
  api_id    = aws_apigatewayv2_api.weather.id
  route_key = "GET /weather"
  authorization_type = "CUSTOM"
  authorizer_id = aws_apigatewayv2_authorizer.weather.id
  target    = "integrations/${aws_apigatewayv2_integration.get_weather.id}"
}

resource "aws_apigatewayv2_route" "update_weather" {
  api_id    = aws_apigatewayv2_api.weather.id
  route_key = "POST /weather"
  authorization_type = "CUSTOM"
  authorizer_id = aws_apigatewayv2_authorizer.weather.id
  target    = "integrations/${aws_apigatewayv2_integration.update_weather.id}"
}
