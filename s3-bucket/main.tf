# Create a bucket and asign a policy to it.

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.tf-demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "tf-demo" {
  bucket = var.bucket-name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name    = var.resource-tags.Name
    Project = var.resource-tags.Project
  }
}