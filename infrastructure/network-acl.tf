# aws_network_acl.btsec-pov-network-acl:
resource "aws_network_acl" "btsec-pov-network-acl" {
  vpc_id = aws_vpc.btsec-pov-vpc.id
  egress = [
    {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 0
      icmp_code       = 0
      icmp_type       = 0
      ipv6_cidr_block = ""
      protocol        = "-1"
      rule_no         = 100
      to_port         = 0
    },
  ]
  ingress = [
    {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 0
      icmp_code       = 0
      icmp_type       = 0
      ipv6_cidr_block = ""
      protocol        = "-1"
      rule_no         = 100
      to_port         = 0
    },
  ]
  subnet_ids = [
    aws_subnet.btsec-pov-subnet1.id,
    aws_subnet.btsec-pov-subnet2.id,
    aws_subnet.btsec-pov-subnet3.id,
    aws_subnet.btsec-pov-subnet4.id,
  ]
}