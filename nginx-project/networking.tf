locals {
  common_tags = {
    ManagedBy = "Terraform"
  }
}

// Local values are like a function's temporary local variables. A local value assigns a name to an expression, so you can use the name multiple times within a module instead of repeating the expression.

resource "aws_vpc" "nginx-project" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.common_tags, {
    Name = "Nginx-Vpc"
  })
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.nginx-project.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "nginx-gw" {
  vpc_id = aws_vpc.nginx-project.id
}

resource "aws_route_table" "nginx-rt" {
  vpc_id = aws_vpc.nginx-project.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx-gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.nginx-rt.id
}

