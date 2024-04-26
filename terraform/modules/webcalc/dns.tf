data "aws_route53_zone" "my_zone" {
  name = "alenak.xyz"
}

data "aws_acm_certificate" "my_certificate" {
  domain   = "webcalc.alenak.xyz"
  statuses = ["ISSUED"]
}

resource "aws_route53_record" "webcalc_cname" {
  zone_id = data.aws_route53_zone.my_zone.id
  name    = data.aws_acm_certificate.my_certificate.domain
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.webcalc_distribution.domain_name]
}
