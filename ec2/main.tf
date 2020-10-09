# Create a security group for our EC2 instance
resource "aws_security_group" "allow-ssh" {
  name        = "allow_ssh"
  description = "Allow inbound ssh traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "SSH from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.current-public-ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_iam_role" "this" {
  name = "tf-demo-ec2-s3-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Project = var.resource-tags.Project
  }
}
resource "aws_iam_role_policy" "this" {
  name = "ec2-s3-access-policy"
  role = aws_iam_role.this.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${var.bucket-name}",
          "arn:aws:s3:::${var.bucket-name}/*"
          ]
      }
    ]
  }
  EOF
}
resource "aws_iam_instance_profile" "this" {
  name = "tf-demo-ec2-s3-iprofile"
  role = aws_iam_role.this.name
}

# Find the latest amazon linux ami for my region/provider.
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  owners = ["amazon"]
}

resource "aws_instance" "tf-demo-instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance-type
  key_name                    = var.keypair-name
  associate_public_ip_address = true
  subnet_id                   = var.vpc-subnet-id
  vpc_security_group_ids      = [aws_security_group.allow-ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name

  tags = {
    Name    = var.resource-tags.Name
    Project = var.resource-tags.Project
  }
}