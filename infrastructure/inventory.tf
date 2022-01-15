resource "local_file" "ansible_inventory" {
  filename = "../configuration/inventory.yaml"
  depends_on = [
    aws_instance.btsec-pov-control-plane,
    aws_instance.btsec-pov-worker-node
  ]
  content = <<EOF
all:
  vars:
    ansible_user: centos
    ansible_port: 22
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
    ansible_ssh_private_key_file: "${var.key}"
    cluster_name: ${var.cluster_name}
  hosts:
%{for index, cp in aws_instance.btsec-pov-control-plane~}
    ${cp.private_ip}:
      node_pool: control
%{endfor~}
%{for index, wk in aws_instance.btsec-pov-worker-node~}
    ${wk.private_ip}:
      node_pool: worker
%{endfor~}
EOF
}
