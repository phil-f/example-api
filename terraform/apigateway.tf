resource "aws_apigatewayv2_api" "weather_station" {
  name          = "weather-station-api-gateway"
  protocol_type = "HTTP"
  disable_execute_api_endpoint = true

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_domain_name" "weather_station" {
  domain_name = var.domain

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.this.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.weather_station.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api_mapping" "weather_station" {
  api_id      = aws_apigatewayv2_api.weather_station.id
  domain_name = aws_apigatewayv2_domain_name.weather_station.id
  stage       = aws_apigatewayv2_stage.default.id
}

resource "aws_apigatewayv2_integration" "weather_station_get" {
  api_id                 = aws_apigatewayv2_api.weather_station.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.weather_station_get.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "weather_station_update" {
  api_id                 = aws_apigatewayv2_api.weather_station.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.weather_station_update.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "get_weather" {
  api_id    = aws_apigatewayv2_api.weather_station.id
  route_key = "GET /weather"
  target    = "integrations/${aws_apigatewayv2_integration.weather_station_get.id}"
}

resource "aws_apigatewayv2_route" "update_weather" {
  api_id    = aws_apigatewayv2_api.weather_station.id
  route_key = "POST /weather"
  target    = "integrations/${aws_apigatewayv2_integration.weather_station_update.id}"
}
