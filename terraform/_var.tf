variable "domain" {
  type    = string
}

variable "cloudflare_zone_id" {
  type    = string
}

variable "resource_prefix" {
  type = string
  default = "test-"
}
