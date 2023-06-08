terraform {
  backend "s3" {
    bucket = "web-app-terraform"
    key    = "web-app-terraform"
    region = "us-east-1"
  }
}