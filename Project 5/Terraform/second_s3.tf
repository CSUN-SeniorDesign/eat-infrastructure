// S3
resource "aws_s3_bucket" "bucket" {
  bucket = "csuneat-project-2"
  acl    = "private"

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix  = "log/"
    tags {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days = 60
      storage_class = "ONEZONE_IA"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
  }

  lifecycle_rule {
    id      = "tmp"
    prefix  = "tmp/"
    enabled = true

    expiration {
      date = "2018-10-10"
    }
  }
}

  
  resource "aws_s3_bucket_object" "Tar-Folder" {
    bucket = "${aws_s3_bucket.bucket.id}"
    acl    = "private"
    key    = "/Uploads/"
    source = "/dev/null"
}


