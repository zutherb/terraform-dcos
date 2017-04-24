resource "aws_security_group" "slave" {
  name = "${var.stack_name}-slave"
  description = "Mesos Slaves"

  vpc_id = "${var.aws_vpc_id}"
}

resource "aws_security_group_rule" "slave_egress_all" {
  security_group_id = "${aws_security_group.slave.id}"

  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "slave_ingress_slave" {
  security_group_id = "${aws_security_group.slave.id}"
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = "${aws_security_group.slave.id}"
}

resource "aws_security_group_rule" "slave_ingress_master" {
  security_group_id = "${aws_security_group.slave.id}"
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = "${aws_security_group.master.id}"
}

resource "aws_security_group_rule" "slave_ingress_public_slave" {
  security_group_id = "${aws_security_group.slave.id}"
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = "${aws_security_group.public_slave.id}"
}


resource "aws_security_group_rule" "slave_ingress_all_vpn" {
  security_group_id = "${aws_security_group.slave.id}"
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = "sg-efd40c92" # vpn_systems Security Group
}

resource "aws_security_group_rule" "slave_ingress_ssh" {
  security_group_id = "${aws_security_group.slave.id}"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
}

resource "aws_security_group_rule" "slave_ingress_http" {
  security_group_id = "${aws_security_group.slave.id}"
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
}

resource "aws_security_group_rule" "slave_ingress_marathon_lb" {
  security_group_id = "${aws_security_group.slave.id}"
  type        = "ingress"
  from_port   = 10000
  to_port     = 10100
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
}
