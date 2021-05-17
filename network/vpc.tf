data "aws_availability_zones" "available" {}


# VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = var.vpc_name
  }
}

#Subnets
#Public Subnet
resource "aws_subnet" "public_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.${10+count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
      Name = "public_subnet"
  }
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.${20+count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
      Name = "private_subnet"
  }
}

# #VPC Elastic IP
# resource "aws_eip" "eip" {
#   vpc = true

#   tags = {
#     Name = "Elastic IP"
#   }
# }

#Public Route Table
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_route_table"
  }
}

#Public Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.rt_public.id
}

#Internet Gatway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Internet-Gateway"
  }
}

# # NatGatways
# resource "aws_nat_gateway" "nat-gw" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = element(aws_subnet.private_subnet.*.id, 0)

#   tags = {
#     Name = "Nat_gateway"
#   }
# }

#Private Route Table
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.myvpc.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat-gw.id
  # }

  tags = {
    Name = "Private_route_table"
  }
}

#Private Route Table Association
resource "aws_route_table_association" "private_sub" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.rt_private.id
}