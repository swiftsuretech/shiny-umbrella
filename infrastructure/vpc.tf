resource "aws_vpc" "btsec-pov-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "btsec-vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.btsec-pov-vpc.id
  cidr_block = "10.10.0.0/16"
}
