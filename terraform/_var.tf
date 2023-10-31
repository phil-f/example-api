variable "domain" {
  type    = string
}

variable "cloudflare_zone_id" {
  type    = string
}

variable "resource_prefix" {
  type = string
  default = "example-"
}

variable "get_weather_archive" {
  type = string
  default = "../app/get-weather/index.zip"
}

variable "update_weather_archive" {
  type = string
  default = "../app/update-weather/index.zip"
}

variable "weather_authorizer_archive" {
  type = string
  default = "../app/authorizer/index.zip"
}
