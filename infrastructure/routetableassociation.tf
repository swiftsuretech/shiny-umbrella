resource "aws_route_table_association" "btsec-pov-rta" {
  subnet_id      = aws_subnet.btsec-pov-subnet1.id
  route_table_id = aws_route_table.btsec-pov-public-rt.id
}
