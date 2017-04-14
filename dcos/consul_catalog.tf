provider "consul" {
    datacenter = "${var.consul_datacenter}"
    address = "consul.service.canary.sh"
}

resource "consul_catalog_entry" "dcos_master" {
    datacenter = "${var.consul_datacenter}"
    address = "${aws_elb.internal_master.dns_name}"
    node = "catalog-dcos-master"
    service = {
        name = "dcos"
    }
}

resource "consul_catalog_entry" "dcos_public" {
    datacenter = "${var.consul_datacenter}"
    address = "${aws_elb.public_slaves.dns_name}"
    node = "catalog-dcos-public"
    service = {
        name = "dcos-public"
    }
}

resource "consul_catalog_entry" "dcos_private" {
    datacenter = "${var.consul_datacenter}"
    address = "${aws_elb.slaves.dns_name}"
    node = "catalog-dcos-private"
    service = {
        name = "dcos-private"
    }
}

resource "consul_catalog_entry" "dcos_example_nginx" {
    datacenter = "${var.datacenter}"
    address = "${aws_elb.public_slaves.dns_name}"
    node = "catalog-dcos-examle-nginx"
    service = {
        name = "dcos-example-nginx"
        port = 80
    }
}

resource "consul_catalog_entry" "dcos_broadcaster_subscriber" {
    datacenter = "${var.datacenter}"
    address = "${aws_elb.public_slaves.dns_name}"
    node = "catalog-dcos-watch-live-broadcaster-subscriber"
    service = {
        name = "watch-live-broadcaster-subscriber"
        port = 443
    }
}

resource "consul_catalog_entry" "dcos_broadcaster_producer" {
    datacenter = "${var.datacenter}"
    address = "${aws_elb.public_slaves.dns_name}"
    node = "catalog-dcos-watch-live-broadcaster-producer"
    service = {
        name = "watch-live-broadcaster-producer"
        port = 443
    }
}
