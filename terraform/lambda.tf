resource "aws_lambda_function" "weather_station_get" {
  filename         = "../app/get-weather/index.zip"
  function_name    = "computerstad-weather-station-get"
  role             = aws_iam_role.weather_station_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("../app/get-weather/index.zip")
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 3

  environment {
    variables = {
      WEATHER_TABLE_NAME = "weather"  
    }
  }
}

resource "aws_lambda_permission" "weather_station_get" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weather_station_get.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.weather_station.execution_arn}/*/*"
}

resource "aws_lambda_function" "weather_station_update" {
  filename         = "../app/update-weather/index.zip"
  function_name    = "computerstad-weather-station-update"
  role             = aws_iam_role.weather_station_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("../app/update-weather/index.zip")
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 3

  environment {
    variables = {
      WEATHER_TABLE_NAME = "weather"
    }
  }
}

resource "aws_lambda_permission" "weather_station_update" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weather_station_update.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.weather_station.execution_arn}/*/*"
}
