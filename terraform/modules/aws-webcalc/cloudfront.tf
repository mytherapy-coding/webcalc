# Define CloudFront distribution
resource "aws_cloudfront_distribution" "webcalc_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  # Define ALB origin
  origin {
    domain_name = aws_lb.webcalc_alb.dns_name
    origin_id   = "webcalc-alb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.3"]
    }
  }

  # Define default cache behavior for all paths
  default_cache_behavior {
    target_origin_id       = "webcalc-alb"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # Define allowed and cached methods for default cache behavior
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    default_ttl = 3600  # Default TTL (in seconds)
    min_ttl     = 0     # Minimum TTL (in seconds)
    max_ttl     = 86400 # Maximum TTL (in seconds)
  }

  # Specify viewer certificate for HTTPS
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.my_certificate.arn
    ssl_support_method  = "sni-only"
  }

  # Specify domain aliases for the distribution
  aliases = [
    data.aws_acm_certificate.my_certificate.domain,
    join(".", ["www", data.aws_acm_certificate.my_certificate.domain])
  ]

  # Restrict access based on geographic location (optional)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
