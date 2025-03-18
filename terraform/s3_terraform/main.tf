provider "aws" {
  region = "us-east-1"
}

# --------------------------
# Create S3 Bucket for Terraform state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "demo-s3-treeleaf"
  acl    = "private"
}
