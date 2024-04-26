data "aws_acm_certificate" "my_certificate" {
  domain   = "alenak.xyz"
  statuses = ["ISSUED"]
}

resource "aws_route53_record" "webcalc_cname" {
  zone_id = data.aws_route53_zone.my_zone.id  # ID of the Route 53 hosted zone for alenak.xyz
  name    = "webcalc.alenak.xyz"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.webcalc_distribution.domain_name]  # Replace with your CloudFront distribution domain
}
