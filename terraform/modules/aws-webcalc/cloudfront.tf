resource "aws_cloudfront_distribution" "webcalc_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = aws_s3_object.webcalc["index"].key
  price_class         = "PriceClass_100"

  origin {
    domain_name              = aws_s3_bucket.webcalc_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.webcalc_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  # Define ALB origin
  origin {
    domain_name = aws_lb.webcalc_alb.dns_name
    origin_id   = "webcalc-alb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Define default cache behavior for all paths
  ordered_cache_behavior {
    path_pattern           = "/api/*" # Forward paths starting with /api/ to ALB
    target_origin_id       = "webcalc-alb"
    viewer_protocol_policy = "redirect-to-https"


    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    

    # Define allowed and cached methods for default cache behavior
    allowed_methods = ["GET", "HEAD", "POST", "OPTIONS", "DELETE", "PUT", "PATCH"]
    cached_methods  = ["GET", "HEAD"]

    default_ttl = 3600  # Default TTL (in seconds)
    min_ttl     = 0     # Minimum TTL (in seconds)
    max_ttl     = 86400 # Maximum TTL (in seconds)
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.webcalc_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
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

data "aws_iam_policy_document" "allow_access" {
  statement {
    sid       = "AllowCloudFrontServicePrincipal"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.webcalc_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.webcalc_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.webcalc_bucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}



resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "example-s3-oac"
  description                       = "AOC Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


