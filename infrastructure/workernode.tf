resource "aws_instance" "btsec-pov-worker-node" {
  ami                                  = "ami-0686851c4e7b1a8e1"
  associate_public_ip_address          = false
  availability_zone                    = "us-west-2b"
  disable_api_termination              = false
  ebs_optimized                        = false
  get_password_data                    = false
  hibernation                          = false
  iam_instance_profile                 = "${var.cluster_name}-iam-profile"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.2xlarge"
  ipv6_address_count                   = 0
  ipv6_addresses                       = []
  key_name                             = trimsuffix(var.key, ".pem")
  monitoring                           = false
  private_ip                           = "10.0.0.3${count.index}"
  secondary_private_ips                = []
  source_dest_check                    = true
  subnet_id                            = aws_subnet.btsec-pov-subnet.id
  count                                = 4
  tags = {
    name       = "${var.cluster_name}-worker-node-${count.index}"
    Name       = "${var.cluster_name}-worker-node-${count.index}"
    expiration = "5d"
    owner      = "@Dave Whitehouse"
  }
  tenancy = "default"
  vpc_security_group_ids = [
    aws_security_group.btset-pov-private-sg.id
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
      "Name" = "${var.cluster_name}-worker-node-${count.index}"
    }
  }
}
