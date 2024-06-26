# Define the AWS S3 bucket for hosting the static website
resource "aws_s3_bucket" "webcalc_bucket" {
  bucket = "static-webcalc-2" # Replace with your unique bucket name
}

resource "aws_s3_bucket_website_configuration" "webcalc" {
  bucket = aws_s3_bucket.webcalc_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "webcalc" {
  bucket = aws_s3_bucket.webcalc_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "webcalc" {
  bucket = aws_s3_bucket.webcalc_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  files = {
    index = {
      name = "index.html"
      type = "text/html"
    },
    style = {
      name = "styles.css"
      type = "text/css"
    },
    script = {
      name = "script.js"
      type = "application/javascript"
    },
    favicon = {
      name = "favicon.png"
      type = "image/png"
    },
  }
  source_path = "../../../static/"
}

resource "aws_s3_object" "webcalc" {
  for_each = local.files

  bucket        = aws_s3_bucket.webcalc_bucket.id
  key           = each.value.name
  source        = join("/", [local.source_path, each.value.name])
  content_type  = each.value.type
  etag          = filemd5(join("/", [local.source_path, each.value.name]))
  cache_control = "max-age=60"
}

