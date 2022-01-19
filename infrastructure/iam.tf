/*
resource "aws_iam_role" "btsec_role" {
  name        = "${var.cluster_name}-role"
  description = "BT POV role for twin airgapped env't"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    name       = "${var.cluster_name}-role"
    expiration = "5d"
    owner      = "@Dave Whitehouse"
  }
}

resource "aws_iam_role_policy" "agent_policy" {
  name   = "${var.cluster_name}-policy"
  role   = aws_iam_role.btsec_role.id
  policy = <<EOF
{
    "Statement": [
        {
            "Sid": "KubernetesCloudProvider",
            "Action": [
              "ec2:CreateTags",
              "ec2:DeleteTags",
              "ec2:DescribeTags",
              "ec2:DescribeInstances",
              "ec2:CreateVolume",
              "ec2:DeleteVolume",
              "ec2:AttachVolume",
              "ec2:DetachVolume",
              "ec2:DescribeVolumes",
              "ec2:DescribeVolumeStatus",
              "ec2:DescribeVolumeAttribute",
              "ec2:ModifyVolume",
              "ec2:DescribeVolumesModifications",
              "ec2:CreateSnapshot",
              "ec2:CopySnapshot",
              "ec2:DeleteSnapshot",
              "ec2:DescribeSnapshots",
              "ec2:DescribeSnapshotAttribute",
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:CreateRoute",
              "ec2:CreateSecurityGroup",
              "ec2:DeleteSecurityGroup",
              "ec2:DeleteRoute",
              "ec2:DescribeRouteTables",
              "ec2:DescribeSubnets",
              "ec2:DescribeSecurityGroups",
              "ec2:ModifyInstanceAttribute",
              "ec2:RevokeSecurityGroupIngress",
              "elasticloadbalancing:AddTags",
              "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
              "elasticloadbalancing:AttachLoadBalancerToSubnets",
              "elasticloadbalancing:ConfigureHealthCheck",
              "elasticloadbalancing:CreateLoadBalancer",
              "elasticloadbalancing:CreateLoadBalancerListeners",
              "elasticloadbalancing:CreateLoadBalancerPolicy",
              "elasticloadbalancing:DeleteLoadBalancer",
              "elasticloadbalancing:DeleteLoadBalancerListeners",
              "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
              "elasticloadbalancing:DescribeLoadBalancerAttributes",
              "elasticloadbalancing:DescribeLoadBalancers",
              "elasticloadbalancing:DescribeTags",
              "elasticloadbalancing:DetachLoadBalancerFromSubnets",
              "elasticloadbalancing:ModifyLoadBalancerAttributes",
              "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
              "elasticloadbalancing:RemoveTags",
              "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "btsec_iam_profile" {
  name = "${var.cluster_name}-iam-profile"
  role = aws_iam_role.btsec_role.id
}
*/