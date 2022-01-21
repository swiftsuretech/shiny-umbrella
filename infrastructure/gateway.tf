resource "aws_internet_gateway" "btsec-pov-gateway" {
  vpc_id = aws_vpc.btsec-pov-vpc.id
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-gateway",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))
}
