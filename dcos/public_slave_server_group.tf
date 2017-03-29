resource "aws_autoscaling_group" "public_slave_server_group" {
  name = "${var.stack_name}-Public-Slaves"

  min_size = "${var.public_slave_instance_count}"
  max_size = "${var.public_slave_instance_count}"
  desired_capacity = "${var.public_slave_instance_count}"

  load_balancers = ["${aws_elb.public_slaves.id}"]

  vpc_zone_identifier = [
    "${var.aws_subnet_public_a_id}",
    "${var.aws_subnet_public_b_id}",
    "${var.aws_subnet_public_c_id}",
  ]
  launch_configuration = "${aws_launch_configuration.public_slave.id}"

  tag {
    key = "role"
    value = "mesos-slave"
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "${var.env}-mesos-slave"
    propagate_at_launch = true
  }

  tag {
    key = "environment"
    value = "${var.env}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = false
  }
}
