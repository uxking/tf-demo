variable "bucket-name" {
  type        = string
  description = "Bucket name - must be unique across all AWS."
}

variable "resource-tags" {
  type        = map
  description = "Tags for the s3-bucket resource."
}