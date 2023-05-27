terraform {
  backend "s3" {
    bucket = "devop-a2-s3864916"
    key = "global/s3/terraform.state"
    region = "us-east-1"
    dynamodb_table = "terraform_state_lock"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "devop-a2-s3864916"
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "state_bucket_lock" {
  name           = "terraform_state_lock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
