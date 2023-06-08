resource "aws_route53_zone" "dns" {
  name = var.domain_name
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = {
    Environment = var.environment_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.dns.zone_id
}

resource "aws_acm_certificate_validation" "dns" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dns : record.fqdn]
}

###########################RECORDS#######################################

resource "aws_route53_record" "www-dev" {
  zone_id = aws_route53_zone.dns.zone_id
  name    = "app"
  type    = "CNAME"
  ttl     = 5

  records = ["${aws_cloudfront_distribution.cdn.domain_name}"]
}