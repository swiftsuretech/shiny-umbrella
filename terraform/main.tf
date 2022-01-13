terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = var.aws_profile
  region  = "us-west-2"
}


locals {
  bastion_l = aws_instance.btsec-pov-bastion-instance.private_ip
  bastion_r = aws_instance.btsec-pov-bastion-instance.public_ip
  control   = aws_instance.btsec-pov-control-plane.*.private_ip
  workers   = aws_instance.btsec-pov-worker-node.*.private_ip
  connect   = "ssh -i ../keys/btsec_twin.pem centos@${aws_instance.btsec-pov-bastion-instance.public_ip}"
}

output "output" {

  value = <<EOT

  Bastion Host Remote IP:

    ${local.bastion_r}
  
  Bastion Host Local IP:

    ${local.bastion_l}

  Control Plane Local IPs:

  %{for node in local.control~}
    ${node}
  %{endfor~}  

  Worker Node Local IPs:

  %{for node in local.workers~}
    ${node}
  %{endfor~}  

  SSH Connection Statement:

  ${local.connect}
  
  EOT
}
