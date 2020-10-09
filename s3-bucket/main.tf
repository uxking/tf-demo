# Create a bucket and asign a policy to it.
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