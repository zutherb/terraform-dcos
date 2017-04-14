output "internal_master_dns" {
  value = "${aws_elb.internal_master.dns_name}"
}

output "public_slave_dns" {
  value = "${aws_elb.public_slaves.dns_name}"
}

output "slave_dns" {
  value = "${aws_elb.slaves.dns_name}"
}
