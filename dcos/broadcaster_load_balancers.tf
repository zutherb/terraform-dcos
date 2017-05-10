resource "aws_elb" "broadcaster_00_d" {
  name = "${var.stack_name}-broadcaster-00-d-lb"

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
    instance_port = 10001
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }
}

resource "aws_elb" "broadcaster_00_m" {
  name = "${var.stack_name}-broadcaster-00-m-lb"

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
    instance_port = 10002
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }
}

resource "aws_elb" "broadcaster_01_d" {
  name = "${var.stack_name}-broadcaster-01-d-lb"

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
    instance_port = 10003
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }
}

resource "aws_elb" "broadcaster_01_m" {
  name = "${var.stack_name}-broadcaster-01-m-lb"

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
    instance_port = 10004
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }
}
