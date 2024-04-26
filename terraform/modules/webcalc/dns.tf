data "aws_route53_zone" "my_zone" {
  name = "alenak.xyz"  # Specify the domain name of your Route 53 hosted zone
}

data "aws_acm_certificate" "my_certificate" {
  domain   = "webcalc.alenak.xyz"
  statuses = ["ISSUED"]
}

resource "aws_route53_record" "webcalc_cname" {
  zone_id = data.aws_route53_zone.my_zone.id  # ID of the Route 53 hosted zone for alenak.xyz
  name    = "webcalc.alenak.xyz"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.webcalc_distribution.domain_name]  # Replace with your CloudFront distribution domain
}

#   program = ["bash", "-c", "terraform show -json | jq -r '.values.root_module.resources[] 
#   | select(.type == \"aws_acm_certificate\") | .values.domain_validation_options[] | .resource_record_name, 
#   .resource_record_type, .resource_record_value'"]
