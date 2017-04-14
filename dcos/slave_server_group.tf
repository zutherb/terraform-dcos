resource "aws_autoscaling_group" "slave_server_group" {
  name = "${var.stack_name}-Slaves"

  min_size = "${var.slave_instance_count}"
  max_size = "${var.slave_instance_count}"
  desired_capacity = "${var.slave_instance_count}"

  load_balancers = ["${aws_elb.slaves.id}"]

  vpc_zone_identifier = [
    "${var.aws_subnet_private_a_id}",
    "${var.aws_subnet_private_b_id}",
    "${var.aws_subnet_private_c_id}",
  ]
  launch_configuration = "${aws_launch_configuration.slave.id}"

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
