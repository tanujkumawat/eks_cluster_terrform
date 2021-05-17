output "vpc_name" {
    value = var.vpc_name
}
output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}
output "private_subnet" {
  value = [aws_subnet.private_subnet.*.id]
}

output "vpc_id" {
    value = "aws_vpc.myvpc.id"
}