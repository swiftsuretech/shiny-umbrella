resource "aws_instance" "btsec-pov-control-plane" {
  ami                                  = "ami-0686851c4e7b1a8e1"
  associate_public_ip_address          = false
  availability_zone                    = "us-west-2b"
  disable_api_termination              = false
  ebs_optimized                        = false
  get_password_data                    = false
  hibernation                          = false
  iam_instance_profile                 = "control-plane.cluster-api-provider-aws.sigs.k8s.io"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.xlarge"
  ipv6_address_count                   = 0
  ipv6_addresses                       = []
  key_name                             = trimsuffix(var.key, ".pem")
  monitoring                           = false
  private_ip                           = "10.0.0.8${count.index}"
  secondary_private_ips                = []
  source_dest_check                    = true
  subnet_id                            = aws_subnet.btsec-pov-subnet2.id
  count                                = 3

  tags = (merge(
    var.tags,
    tomap({
      "Name" : "${var.cluster_name}-control-plane-${count.index}",
      "konvoy/nodeRoles" : "control_plane",
      "kubernetes.io/cluster/${var.cluster_name}" : "owned",
      "kubernetes.io/cluster" : "${var.cluster_name}",
      "expiration" = "5d"
      "owner"      = "@Dave Whitehouse"
      }
    )
  ))

  tenancy = "default"
  vpc_security_group_ids = [
    aws_security_group.btsec-aws-controlplane-sg.id
  ]

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  enclave_options {
    enabled = false
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    throughput            = 0
    volume_size           = 100
    volume_type           = "gp2"
    tags = {
      "Name" = "${var.cluster_name}-control-plane-${count.index}"
    }
  }
}
