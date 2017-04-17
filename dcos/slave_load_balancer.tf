resource "aws_elb" "slaves" {
  name = "${var.stack_name}-slave-lb"
  internal = true

  subnets = [
    "${var.aws_subnet_private_a_id}",
    "${var.aws_subnet_private_b_id}",
    "${var.aws_subnet_private_c_id}",
  ]

  security_groups = ["${aws_security_group.slave.id}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:9090/_haproxy_health_check"
    interval = 30
  }

  listener {
    instance_port = 10010
    instance_protocol = "tcp"
    lb_port = 10010
    lb_protocol = "tcp"
  }

  listener {
    instance_port = 10011
    instance_protocol = "tcp"
    lb_port = 10011
    lb_protocol = "tcp"
  }
}
