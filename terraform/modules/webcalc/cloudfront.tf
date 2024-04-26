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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.my_certificate.arn
    ssl_support_method  = "sni-only"
  }

  aliases = [
    data.aws_acm_certificate.my_certificate.domain,
    join(".", ["www", data.aws_acm_certificate.my_certificate.domain])
  ]
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


