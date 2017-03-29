output "dcos_cli" {
  value = "ssh ubuntu@${aws_instance.dcos.private_ip}"
}

output "internal_master" {
  value = "http://${aws_elb.internal_master.dns_name}"
}

output "public_slave" {
  value = "${aws_elb.public_slaves.dns_name}"
}
