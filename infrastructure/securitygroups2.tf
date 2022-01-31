# aws_security_group.btsec-aws-apiserver-lb:
resource "aws_security_group" "btsec-aws-apiserver-lb" {
  name        = "btsec-pov-add1-apiserver-lb"
  description = "Kubernetes cluster btsec-pov: apiserver-lb"
  vpc_id      = aws_vpc.btsec-pov-vpc.id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      protocol         = "-1"
      self             = false
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Kubernetes API"
      from_port        = 6443
      protocol         = "tcp"
      self             = false
      to_port          = 6443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-cp-elb",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))
  timeouts {}
}


# aws_security_group.btsec-aws-controlplane:
resource "aws_security_group" "btsec-aws-controlplane" {
  name        = "btsec-pov-add1-controlplane"
  description = "Kubernetes cluster btsec-pov: controlplane"
  vpc_id      = aws_vpc.btsec-pov-vpc.id
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      protocol         = "-1"
      self             = false
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "IP-in-IP (calico)"
      from_port        = 0
      protocol         = "4"
      self             = true
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "Kubernetes API"
      from_port   = 6443
      protocol    = "tcp"
      self        = true
      to_port     = 6443
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "NVIDIA Data Center GPU Manager metrics"
      from_port   = 9400
      protocol    = "tcp"
      self        = true
      to_port     = 9400
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "Prometheus node exporter metrics"
      from_port   = 9100
      protocol    = "tcp"
      self        = true
      to_port     = 9100
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "SSH"
      from_port   = 22
      protocol    = "tcp"
      self        = false
      to_port     = 22
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "bgp (calico)"
      from_port   = 179
      protocol    = "tcp"
      self        = true
      to_port     = 179
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "containerd metrics"
      from_port   = 1338
      protocol    = "tcp"
      self        = true
      to_port     = 1338
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "etcd peer"
      from_port   = 2380
      protocol    = "tcp"
      self        = true
      to_port     = 2380
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "etcd"
      from_port   = 2379
      protocol    = "tcp"
      self        = true
      to_port     = 2379
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "kube-proxy metrics"
      from_port   = 10249
      protocol    = "tcp"
      self        = true
      to_port     = 10249
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description = "typha (calico)"
      from_port   = 5473
      protocol    = "tcp"
      self        = true
      to_port     = 5473
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-cp-elb",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))
  timeouts {}
}



# aws_security_group.btsec-aws-bastion:
resource "aws_security_group" "btsec-aws-bastion" {
  name        = "btsec-pov-add1-bastion"
  description = "Kubernetes cluster btsec-pov: bastion"
  vpc_id      = aws_vpc.btsec-pov-vpc.id
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      protocol         = "-1"
      self             = false
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "SSH"
      from_port        = 22
      protocol         = "tcp"
      self             = false
      to_port          = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-cp-elb",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))
  timeouts {}
}



# aws_security_group.btsec-aws-node:
resource "aws_security_group" "btsec-aws-node" {
  name        = "BTSEC POV node security group"
  description = "Kubernetes cluster btsec-pov: node"
  vpc_id      = aws_vpc.btsec-pov-vpc.id
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      protocol         = "-1"
      self             = false
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Node Port Services"
      from_port        = 30000
      protocol         = "tcp"
      self             = false
      to_port          = 32767
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "IP-in-IP (calico)"
      from_port        = 0
      protocol         = "4"
      self             = true
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Kubelet API"
      from_port        = 10250
      protocol         = "tcp"
      self             = true
      to_port          = 10250
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "NVIDIA Data Center GPU Manager metrics"
      from_port        = 9400
      protocol         = "tcp"
      self             = true
      to_port          = 9400
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Prometheus node exporter metrics"
      from_port        = 9100
      protocol         = "tcp"
      self             = true
      to_port          = 9100
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "SSH"
      from_port        = 22
      protocol         = "tcp"
      self             = false
      to_port          = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "bgp (calico)"
      from_port        = 179
      protocol         = "tcp"
      self             = true
      to_port          = 179
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "containerd metrics"
      from_port        = 1338
      protocol         = "tcp"
      self             = true
      to_port          = 1338
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "kube-proxy metrics"
      from_port        = 10249
      protocol         = "tcp"
      self             = true
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      to_port          = 10249
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "typha (calico)"
      from_port        = 5473
      protocol         = "tcp"
      self             = true
      to_port          = 5473
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]
  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-cp-elb",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}"
      }
    )
  ))
  timeouts {}
}