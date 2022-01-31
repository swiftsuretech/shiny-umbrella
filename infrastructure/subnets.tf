# aws_subnet.btsec-pov-subnet1:
resource "aws_subnet" "btsec-pov-subnet1" {
  vpc_id                                         = aws_vpc.btsec-pov-vpc.id
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "us-west-2b"
  cidr_block                                     = "10.0.0.128/25"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = true
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-subnet-1",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))

  timeouts {}
}


# aws_subnet.btsec-pov-subnet2:
resource "aws_subnet" "btsec-pov-subnet2" {
  vpc_id                                         = aws_vpc.btsec-pov-vpc.id
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "us-west-2a"
  cidr_block                                     = "10.0.0.0/25"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-subnet-2",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))
  timeouts {}
}