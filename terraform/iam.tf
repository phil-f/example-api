resource "aws_iam_role" "weather_station_lambda" {
  name = "${var.resource_prefix}weather-station"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "weather_station_lambda_cloudwatch_logs" {
  name = "${var.resource_prefix}weather-station-cloudwatch-logs"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : [
          "${aws_cloudwatch_log_group.weather_station_get.arn}:*",
          "${aws_cloudwatch_log_group.weather_station_update.arn}:*",
          "${aws_cloudwatch_log_group.weather_station_authorizer.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "weather_station_dynamo" {
  name = "${var.resource_prefix}weather-station-dynamo"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "dynamodb:DescribeTable",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ],
        Resource : aws_dynamodb_table.weather_station.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "weather_station_lambda_cloudwatch_logs" {
  role       = aws_iam_role.weather_station_lambda.name
  policy_arn = aws_iam_policy.weather_station_lambda_cloudwatch_logs.arn
}

resource "aws_iam_role_policy_attachment" "weather_station_dynamo" {
  role       = aws_iam_role.weather_station_lambda.name
  policy_arn = aws_iam_policy.weather_station_dynamo.arn
}
