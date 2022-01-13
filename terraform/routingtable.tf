resource "aws_route_table" "btsec-pov-public-rt" {
  vpc_id = aws_vpc.btsec-pov-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.btsec-pov-gateway.id
  }
  lifecycle {
    ignore_changes = [route, tags]
  }
  tags = {
    "Name" = "${var.cluster_name}-rt"
  }
}
