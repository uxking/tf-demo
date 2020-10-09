output "vpc-id" {
    value = aws_vpc.tf-demo.id
}

output "vpc-subnet-id" {
    value = aws_subnet.public.id
}
