output "ec2-public-ip" {
  value = aws_instance.tf-demo-instance.public_ip
}