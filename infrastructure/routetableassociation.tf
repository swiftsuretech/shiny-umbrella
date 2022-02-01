resource "aws_route_table_association" "btsec-pov-rta1" {
  subnet_id      = aws_subnet.btsec-pov-subnet1.id
  route_table_id = aws_route_table.btsec-pov-public-rt.id
}

resource "aws_route_table_association" "btsec-pov-rta2" {
  subnet_id      = aws_subnet.btsec-pov-subnet2.id
  route_table_id = aws_route_table.btsec-pov-private-rt.id
}

resource "aws_route_table_association" "btsec-pov-rta3" {
  subnet_id      = aws_subnet.btsec-pov-subnet3.id
  route_table_id = aws_route_table.btsec-pov-private-rt.id
}

resource "aws_route_table_association" "btsec-pov-rta4" {
  subnet_id      = aws_subnet.btsec-pov-subnet4.id
  route_table_id = aws_route_table.btsec-pov-private-rt.id
}
