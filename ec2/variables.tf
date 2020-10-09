variable "keypair-name" {
  type        = string
  description = "Key pair to use for ssh login to EC2 instance."
}

variable "instance-type" {
  type        = string
  description = "instance type, ie. t3.micro, c5.2xlarge, etc..."
}

variable "vpc-id" {
  type        = string
  description = "VPC id created from the child module will be passed into the ec2 module."
}

variable "vpc-subnet-id" {
  type        = string
  description = "VPC subnet id created from the child module will be passed into the ec2 module."
}

variable "current-public-ip" {
  type        = string
  description = "Security group will allow ssh access from this IP only."
}

variable "resource-tags" {
  type        = map
  description = "Tags for the instance and associate resources."
}

variable "bucket-name" {
  type        = string
  description = "Bucket name to apply the ec2 iam policy access."
}