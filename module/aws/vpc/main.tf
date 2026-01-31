provider "aws" {
  region = "ap-south-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile = "tuto"
}

resource "aws_vpc" "vpc_net" {
  cidr_block = "11.1.0.0/16"
  assign_generated_ipv6_cidr_block = false
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    Name = "vpc-net"
    Environment = var.environment
    Region = "ap-south-1"
    Organization = "sloopstash"
  }
}
resource "aws_internet_gateway" "vpc_ig" {
  depends_on = [aws_vpc.vpc_net]
  vpc_id = aws_vpc.vpc_net.id
  tags = {
    Name = "vpc-ig"
    Environment = var.environment
    Region = "ap-south-1"
    Organization = "sloopstash"
  }
}

resource "aws_route_table" "vpc_pub_rtt" {
  depends_on = [
    aws_vpc.vpc_net,
    aws_internet_gateway.vpc_ig
  ]
  vpc_id = aws_vpc.vpc_net.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
  }
  tags = {
    Name = "vpc-pub-rtt"
    Environment = var.environment
    Region = "ap-south-1"
    Organization = "sloopstash"
  }
}
resource "aws_route_table" "vpc_pvt_rtt" {
  depends_on = [aws_vpc.vpc_net]
  vpc_id = aws_vpc.vpc_net.id
  tags = {
    Name = "vpc-pvt-rtt"
    Environment = var.environment
    Region = "ap-south-1"
    Organization = "sloopstash"
  }
}