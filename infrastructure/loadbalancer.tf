resource "aws_elb" "btsec-pov-lb" {
  name = "btsec-pov-lb"
  #  availability_zones = ["us-west-2a", "us-west-2b"]
  subnets = [
    aws_subnet.btsec-pov-subnet2.id,
    aws_subnet.btsec-pov-subnet1.id

  ]
  listener {
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 6443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "SSL:6443"
    interval            = 30
  }

  instances                   = aws_instance.btsec-pov-control-plane.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    name       = "${var.cluster_name}-lb"
    Name       = "${var.cluster_name}-lb"
    expiration = "5d"
    owner      = "@Dave Whitehouse"
  }
}