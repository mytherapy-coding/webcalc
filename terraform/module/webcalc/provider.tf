provider "aws" {
  # Required: The region where your AWS resources reside
  region = "us-east-1"

  # Optional: Configure the S3 endpoint (if using a custom endpoint)
  # s3_endpoint = "https://s3.custom.com"  # Example for a custom endpoint

  # Credentials are not set explicitly here (security best practice)
}
