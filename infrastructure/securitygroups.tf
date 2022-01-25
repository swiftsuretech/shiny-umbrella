resource "aws_security_group" "btsec-pov-bastion-sg" {
  description = "Allow inbound SSH for Bastion."
  name        = "BTSEC POV bastion security group"
  vpc_id      = aws_vpc.btsec-pov-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.cluster_name}-bastion-sg"
  }
}


resource "aws_security_group" "btset-pov-private-sg" {
  description = "Allow all communication between instances"
  vpc_id      = aws_vpc.btsec-pov-vpc.id
  name        = "BTSEC POV nodes security group"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-sg-private",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))
}
