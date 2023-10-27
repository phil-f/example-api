resource "aws_dynamodb_table" "weather_station" {
  name         = "weather"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "key"

  attribute {
    name = "key"
    type = "S"
  }
}
