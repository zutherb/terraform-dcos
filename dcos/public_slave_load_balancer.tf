resource "aws_elb" "public_slaves" {
  name = "${var.stack_name}-public-slave-lb"

  subnets = [
    "${var.aws_subnet_public_a_id}",
    "${var.aws_subnet_public_b_id}",
    "${var.aws_subnet_public_c_id}",
  ]

  security_groups = ["${aws_security_group.public_slave.id}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:9090/_haproxy_health_check"
    interval = 30
  }

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 443
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }

  listener {
    instance_port = 10001
    instance_protocol = "tcp"
    lb_port = 10001
    lb_protocol = "tcp"
  }

  listener {
    instance_port = 10002
    instance_protocol = "tcp"
    lb_port = 10002
    lb_protocol = "tcp"
  }

  listener {
    instance_port = 10003
    instance_protocol = "tcp"
    lb_port = 10003
    lb_protocol = "tcp"
  }

  listener {
    instance_port = 10011
    instance_protocol = "tcp"
    lb_port = 10011
    lb_protocol = "tcp"
  }
}
