terraform {
  backend "s3" {
    bucket = "demo-s3-treeleaf"        
    key    = "terraform/state/terraform.tfstate"  # The path to store the state file
    region = "us-east-1"              
    encrypt = true      
  }
}
