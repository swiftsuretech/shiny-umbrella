resource "aws_instance" "btsec-pov-bastion-instance" {
  ami                                  = "ami-0686851c4e7b1a8e1"
  associate_public_ip_address          = true
  availability_zone                    = "us-west-2b"
  disable_api_termination              = false
  ebs_optimized                        = false
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.xlarge"
  ipv6_address_count                   = 0
  ipv6_addresses                       = []
  key_name                             = "btsec_twin"
  monitoring                           = false
  private_ip                           = "10.0.0.10"
  secondary_private_ips                = []
  source_dest_check                    = true
  subnet_id                            = aws_subnet.btsec-pov-subnet.id
  tags = {
    Name       = "${var.cluster_name}-bastion-node"
    expiration = "5d"
    Owner      = "@Dave Whitehouse"
  }
  tenancy = "default"
  vpc_security_group_ids = [
    aws_security_group.btsec-pov-bastion-sg.id
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
      "Name" = "${var.cluster_name}-bastion"
    }
  }

  provisioner "file" {
    source      = var.key
    destination = "/home/centos/.ssh/btsec_twin.pem"
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = file("${var.key}")
      host        = aws_instance.btsec-pov-bastion-instance.public_ip
    }
  }

  provisioner "file" {
    source      = "../scripts/setup_bastion.sh"
    destination = "/home/centos/setup_bastion"
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = file("${var.key}")
      host        = aws_instance.btsec-pov-bastion-instance.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/centos/.ssh/btsec_twin.pem",
      "echo IdentityFile /home/centos/.ssh/btsec_twin.pem > /home/centos/.ssh/config",
      "chmod 600 /home/centos/.ssh/config",
      "chmod +x /home/centos/setup_bastion",
      "/home/centos/setup_bastion",
    ]
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = file("${var.key}")
      host        = aws_instance.btsec-pov-bastion-instance.public_ip
    }
  }
}
