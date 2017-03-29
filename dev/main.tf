provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "cnry-nonprod-terraform-state"
    key    = "dcos/dev/main.tfstate"
    region = "us-east-1"
  }
}

module "dev_dcos" {
    source = "../dcos"
    stack_name = "dev-dcos"
    env = "dev"
    aws_region = "us-east-1"
    slave_instance_count = 2
    aws_vpc_id = "vpc-9c7702f9"
    aws_subnet_public_a_id = "subnet-aa78efdd"
    aws_subnet_public_b_id = "subnet-f944f3a0"
    aws_subnet_public_c_id = "subnet-08c01d23" #actually AZ 1d
    aws_subnet_private_a_id = "subnet-a978efde"
    aws_subnet_private_b_id = "subnet-c744f39e"
    aws_subnet_private_c_id = "subnet-0dc01d26" #actually AZ 1d
}

output "internal_master_dns" {
  value = "${module.dev_dcos.internal_master_dns}"
}

output "public_slave_dns" {
  value = "${module.dev_dcos.public_slave_dns}"
}
