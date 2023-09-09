terraform {
  backend "s3" {
    bucket = "youssef-terraform-vprofile-state"
    key = "terraform/backend"
    region = "us-east-2"
  }
}