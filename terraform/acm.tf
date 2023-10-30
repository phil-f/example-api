resource "aws_acm_certificate" "this" {
  domain_name               = local.domain
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  for_each = cloudflare_record.cert_validation

  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [each.value.hostname]
}
