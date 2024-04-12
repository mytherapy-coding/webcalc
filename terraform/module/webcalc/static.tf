# Define the AWS S3 bucket for hosting the static website
resource "aws_s3_bucket" "webcalc_bucket" {
  bucket = "static-webcalc-2"  # Replace with your unique bucket name

  # Set the ACL to private to comply with Object Ownership settings
  acl    = "private"

  # Enable website hosting with index document
  website {
    index_document = "index.html"
  }

  # Enable server-side encryption (SSE) to support Object Ownership settings
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Enable versioning to support Object Ownership settings
  versioning {
    enabled = true
  }

  
#   # Define a bucket policy to enforce Object Ownership (BucketOwnerEnforced)
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "s3:PutObject",
#       "Resource": "arn:aws:s3:::static-webcalc-2/*",
#       "Condition": {
#         "StringNotEquals": {
#           "s3:x-amz-acl": "bucket-owner-full-control"
#         }
#       }
#     }
#   ]
# }
# EOF
}

# Upload the index.html file to the S3 bucket
resource "aws_s3_bucket_object" "webcalc_index" {
  bucket = aws_s3_bucket.webcalc_bucket.id
  etag = filemd5("../../../static/index.html")
  cache_control = "max-age=60"
  key    = "index.html"
  source = "../../../static/index.html"  # Path to your local index.html file
  content_type = "text/html"
}

# Upload the styles.css file to the S3 bucket
resource "aws_s3_bucket_object" "webcalc_css" {
  bucket = aws_s3_bucket.webcalc_bucket.id
  etag = filemd5("../../../static/styles.css")
  cache_control = "max-age=60"
  key    = "styles.css"
  source = "../../../static/styles.css"  # Path to your local styles.css file
  content_type = "text/css"
}

# Upload the script.js file to the S3 bucket
resource "aws_s3_bucket_object" "webcalc_js" {
  bucket = aws_s3_bucket.webcalc_bucket.id
  etag = filemd5("../../../static/script.js")
  cache_control = "max-age=60"
  key    = "script.js"
  source = "../../../static/script.js"  # Path to your local script.js file
  content_type = "application/javascript"
}
