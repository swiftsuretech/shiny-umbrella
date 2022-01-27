resource "aws_elb" "btsec-pov-lb" {
  internal                  = false
  security_groups           = [aws_security_group.btsec-pov-internal-sg.id, aws_security_group.btsec-pov-control-plane-sg.id]
  subnets                   = [aws_subnet.btsec-pov-subnet.id]
  connection_draining       = true
  cross_zone_load_balancing = true


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:6443/healthz"
    interval            = 10
  }

  listener {
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 6443
    lb_protocol       = "tcp"
  }

  instances = aws_instance.btsec-pov-control-plane.*.id

  tags = var.tags
}