resource "cloudflare_record" "weather_station" {
  zone_id = var.cloudflare_zone_id
  name    = local.domain
  value   = aws_apigatewayv2_domain_name.weather_station.domain_name_configuration[0].target_domain_name
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } if dvo.domain_name == local.domain
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  value   = each.value.record
  type    = each.value.type
  ttl     = 60
}