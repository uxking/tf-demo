# Create a vpc in our default region. Can be overriden by sending provider as input
resource "aws_vpc" "tf-demo" {
  cidr_block           = var.network-params.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = var.resource-tags.Name
    Project = var.resource-tags.Project
  }
}

# IGW 
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.tf-demo.id
  tags = {
    Name    = var.resource-tags.Name
    Project = var.resource-tags.Project
  }
}

# Gather AZ data for default region. Can be overriden by sending provider as input
data "aws_availability_zones" "current_region" {
  state = "available"
}

# Create  subnet in default region. Can be overridden by sending provider as input.
resource "aws_subnet" "public" {
  availability_zone = element(data.aws_availability_zones.current_region.names, 0)
  vpc_id            = aws_vpc.tf-demo.id
  cidr_block        = var.network-params.public_sn_1
  tags = {
    Name    = var.resource-tags.Name
    Project = var.resource-tags.Project
  }
}

# Need a route table for the IGW
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.tf-demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name    = var.resource-tags.Name
    Project = var.resource-tags.Project
  }
}

# Associate the route to our subnet
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}