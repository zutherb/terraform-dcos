resource "aws_autoscaling_group" "master_server_group" {
  name = "${var.stack_name}-Masters"

  min_size = "${var.master_instance_count}"
  max_size = "${var.master_instance_count}"
  desired_capacity = "${var.master_instance_count}"

  load_balancers = ["${aws_elb.internal_master.id}"]

  vpc_zone_identifier = ["${var.aws_subnet_private_a_id}"]
  launch_configuration = "${aws_launch_configuration.master.id}"

  tag {
    key = "role"
    value = "mesos-master"
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "${var.env}-mesos-master"
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
