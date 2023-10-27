resource "aws_dynamodb_table" "weather_station" {
  name         = "example-weather"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "key"

  attribute {
    name = "key"
    type = "S"
  }
}
