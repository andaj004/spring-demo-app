terraform {
  backend "s3" {
    bucket  = "demo-s3-treeleaf"  # Use a common S3 bucket for all components
    key     = "terraform/state/dev-cluster/terraform.tfstate"  # A common key path in the bucket
    region  = "us-east-1"
    encrypt = true                    # Enable encryption for security
  }
}
