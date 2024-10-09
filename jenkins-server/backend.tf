terraform {
  backend "s3" {
    bucket = "terraform-backend-for-jenkins"
    key    = "nginx-tf/terraform.tfstate"
    region = "us-east-1"
  }
}