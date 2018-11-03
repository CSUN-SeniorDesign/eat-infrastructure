terraform {
  backend "s3" {
    bucket = "csuneat"
    key    = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
    region = "us-west-2"
  }
}
