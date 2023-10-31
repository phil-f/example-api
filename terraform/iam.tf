// Get Lambda
resource "aws_iam_role" "get_weather" {
  name = "${var.resource_prefix}get-weather"
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

resource "aws_iam_policy" "get_weather_cloudwatch" {
  name = "${var.resource_prefix}get-weather-cloudwatch"

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
          "${aws_cloudwatch_log_group.get_weather.arn}:*",
          "${aws_cloudwatch_log_group.update_weather.arn}:*",
          "${aws_cloudwatch_log_group.weather_authorizer.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "get_weather_dynamo" {
  name = "${var.resource_prefix}get-weather-dynamo"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:Query",
        ],
        Resource : aws_dynamodb_table.weather.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "get_weather_cloudwatch" {
  role       = aws_iam_role.get_weather.name
  policy_arn = aws_iam_policy.get_weather_cloudwatch.arn
}

resource "aws_iam_role_policy_attachment" "get_weather_dynamo" {
  role       = aws_iam_role.get_weather.name
  policy_arn = aws_iam_policy.get_weather_dynamo.arn
}

// Update Lambda
resource "aws_iam_role" "update_weather" {
  name = "${var.resource_prefix}update-weather"
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

resource "aws_iam_policy" "update_weather_dynamo" {
  name = "${var.resource_prefix}update-weather-dynamo"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "dynamodb:DescribeTable",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        Resource : aws_dynamodb_table.weather.arn
      }
    ]
  })
}

resource "aws_iam_policy" "update_weather_cloudwatch" {
  name = "${var.resource_prefix}update-weather-cloudwatch"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "${aws_cloudwatch_log_group.update_weather.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "update_weather_cloudwatch" {
  role       = aws_iam_role.update_weather.name
  policy_arn = aws_iam_policy.update_weather_cloudwatch.arn
}

resource "aws_iam_role_policy_attachment" "update_weather_dynamo" {
  role       = aws_iam_role.update_weather.name
  policy_arn = aws_iam_policy.update_weather_dynamo.arn
}

// Authorizer Lambda
resource "aws_iam_role" "weather_authorizer" {
  name = "${var.resource_prefix}weather-authorizer"
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

resource "aws_iam_policy" "weather_authorizer_cloudwatch" {
  name = "${var.resource_prefix}weather-authorizer-cloudwatch"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "${aws_cloudwatch_log_group.weather_authorizer.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "weather_authorizer_cloudwatch" {
  role       = aws_iam_role.weather_authorizer.name
  policy_arn = aws_iam_policy.weather_authorizer_cloudwatch.arn
}
