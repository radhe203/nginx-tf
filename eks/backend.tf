terraform {
  backend "s3" {
    bucket = "terraform-backend-for-eks-cluster"
    key    = "nginx-tf/terraform.tfstate"
    region = "us-east-1"
  }
}