# Just getting the IP address to ssh into the box.
output "ec2-public-ip" {
  value = module.ec2-demo-instance.ec2-public-ip
}