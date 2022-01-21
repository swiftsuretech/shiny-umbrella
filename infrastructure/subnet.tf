resource "aws_subnet" "btsec-pov-subnet" {
  vpc_id                  = aws_vpc.btsec-pov-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2b"
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-subnet",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))
}
