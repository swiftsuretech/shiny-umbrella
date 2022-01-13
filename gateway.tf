resource "aws_internet_gateway" "btsec-pov-gateway" {
  vpc_id = aws_vpc.btsec-pov-vpc.id
  tags = {
    "Name" = "${var.cluster_name}-gateway"
  }
}
