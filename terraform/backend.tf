terraform {
  backend "s3" {
    bucket = "demo-s3-treeleaf"        # Replace with your bucket name
    key    = "terraform/state/vpc-sg/terraform.tfstate"  # The path to store the state file
    region = "us-east-1"              # AWS region
    encrypt = true                    # Enable encryption for security
  }
}
