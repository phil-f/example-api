resource "aws_lambda_function" "get_weather" {
  filename         = var.get_weather_archive
  function_name    = "${var.resource_prefix}get-weather"
  role             = aws_iam_role.get_weather.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256(var.get_weather_archive)
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 3

  environment {
    variables = {
      WEATHER_TABLE_NAME = aws_dynamodb_table.weather.id  
    }
  }
}

resource "aws_lambda_permission" "get_weather" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_weather.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.weather.execution_arn}/*/*"
}

resource "aws_lambda_function" "update_weather" {
  filename         = var.update_weather_archive
  function_name    = "${var.resource_prefix}update-weather"
  role             = aws_iam_role.update_weather.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256(var.update_weather_archive)
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 3

  environment {
    variables = {
      WEATHER_TABLE_NAME = aws_dynamodb_table.weather.id
    }
  }
}

resource "aws_lambda_permission" "update_weather" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_weather.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.weather.execution_arn}/*/*"
}

resource "aws_lambda_function" "weather_authorizer" {
  filename         = var.weather_authorizer_archive
  function_name    = "${var.resource_prefix}weather-authorizer"
  role             = aws_iam_role.weather_authorizer.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256(var.weather_authorizer_archive)
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 3
}

resource "aws_lambda_permission" "weather_authorizer" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weather_authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.weather.execution_arn}/*/*"
}
