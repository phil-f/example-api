resource "aws_cloudwatch_log_group" "weather_station_get" {
  name              = "/aws/lambda/${aws_lambda_function.weather_station_get.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "weather_station_update" {
  name              = "/aws/lambda/${aws_lambda_function.weather_station_update.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "weather_station_authorizer" {
  name              = "/aws/lambda/${aws_lambda_function.weather_station_authorizer.function_name}"
  retention_in_days = 7
}