resource "aws_apigatewayv2_authorizer" "weather" {
  api_id                            = aws_apigatewayv2_api.weather.id
  authorizer_type                   = "REQUEST"
  authorizer_uri                    = aws_lambda_function.weather_authorizer.invoke_arn
  identity_sources                  = ["$request.header.Authorization"]
  name                              = "${var.resource_prefix}weather-authorizer"
  authorizer_payload_format_version = "2.0"
  enable_simple_responses           = true
}
