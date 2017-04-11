resource "aws_security_group" "public_slave" {
  name = "${var.stack_name}-Public-Slaves"
  description = "Mesos Public Slaves"

  vpc_id = "${var.aws_vpc_id}"
}

resource "aws_security_group_rule" "public_slave_egress_all" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_slave_ingress_public_slave" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  self = true
}

resource "aws_security_group_rule" "public_slave_ingress_master" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = "${aws_security_group.master.id}"
}

resource "aws_security_group_rule" "public_slave_ingress_slave" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = "${aws_security_group.slave.id}"
}

resource "aws_security_group_rule" "public_slave_ingress_0_21_tcp" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 0
  to_port = 21
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_slave_ingress_0_21_udp" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 0
  to_port = 21
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_slave_ingress_80_80_udp" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_slave_ingress_443_443_tcp" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_slave_ingress_broadcast_service_tcp" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 10001
  to_port = 10003
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_slave_ingress_redis_service_tcp" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 10011
  to_port = 10011
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_slave_ingress_23_5050_udp" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 23
  to_port = 5050
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_slave_ingress_5052_65535_udp" {
  security_group_id = "${aws_security_group.public_slave.id}"

  type = "ingress"
  from_port = 5052
  to_port = 65535
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
}
