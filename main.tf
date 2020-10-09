terraform {
  required_version = ">=0.12.0"
}

# Setting up two providers just in case I ever want to deploy in different regions
# Pass a provider to each module if not using the default
/* Example:
module "module-name" {
  source = "module-source"
  providers = {
    aws = aws.region-east
  }
}
*/

# Default provider
provider "aws" {
  profile = var.profile
  region  = var.region-west
}

provider "aws" {
  profile = var.profile
  region  = var.region-east
  alias   = "region_east"
}

module "networking-setup" {
  source = "./networks"

  # Modify resource tags and network params variables as desired.
  resource-tags = {
    Name    = "tf-demo-net-infra"
    Project = "tf-demo"
  }
  network-params = {
    cidr_block  = "10.10.0.0/16"
    public_sn_1 = "10.10.1.0/24"
  }
}

# Create an S3 bucket
module "s3-bucket" {
  source      = "./s3-bucket"
  bucket-name = "tf-demo-2020"

  resource-tags = {
    Name    = "tf-demo-2020-bucket"
    Project = "tf-demo"
  }
}

# Spin up an ec2 instance in our newly created network VPC
module "ec2-demo-instance" {
  source            = "./ec2"
  keypair-name      = "tf-demo"
  instance-type     = "t2.micro"
  vpc-id            = module.networking-setup.vpc-id
  vpc-subnet-id     = module.networking-setup.vpc-subnet-id
  current-public-ip = "140.174.234.6/32"

  # We need to pass this for the IAM policy
  bucket-name = "tf-demo-2020"

  resource-tags = {
    Name    = "tf-demo-instance"
    Project = "tf-demo"
  }
}
