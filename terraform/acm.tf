resource "aws_acm_certificate" "weather" {
  domain_name               = local.domain
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "weather" {
  certificate_arn         = aws_acm_certificate.weather.arn
  validation_record_fqdns = [for record in cloudflare_record.cert_validation : record.hostname]
}
