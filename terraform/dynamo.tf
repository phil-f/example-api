resource "aws_dynamodb_table" "weather_station" {
  name         = "${var.resource_prefix}weather"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "key"

  attribute {
    name = "key"
    type = "S"
  }
}
