provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "csuneat"
  acl = "private"

  tags {
    Name = "Team Eat Bucket"
    Environment = "Dev"
  }
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state"{
  name = "terraform-state-lock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
  tags {
    Name = "DynamoDB Terraform Lock Table"
  }
}
