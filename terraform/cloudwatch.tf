resource "aws_cloudwatch_log_group" "get_weather" {
  name              = "/aws/lambda/${aws_lambda_function.get_weather.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "update_weather" {
  name              = "/aws/lambda/${aws_lambda_function.update_weather.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "weather_authorizer" {
  name              = "/aws/lambda/${aws_lambda_function.weather_authorizer.function_name}"
  retention_in_days = 7
}