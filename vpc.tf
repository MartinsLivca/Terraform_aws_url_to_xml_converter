resource "aws_vpc" "main" {
  cidr_block       = "169.69.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "169.69.1.0/24"
  availability_zone = "eu-north-1a"
}

resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "169.69.2.0/24"
  availability_zone = "eu-north-1b"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_main_route_table_association" "route_table_a" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_default_route_table.route_table.id
}
