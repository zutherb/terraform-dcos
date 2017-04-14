provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "cnry-nonprod-terraform-state"
    key    = "dcos/stage/main.tfstate"
    region = "us-east-1"
  }
}

module "stage_dcos" {
    source = "../dcos"
    env = "stage"
    aws_region = "us-east-1"
    slave_instance_count = 3
    aws_subnet_public_a_id = "subnet-4bd3583c"
    aws_subnet_public_b_id = "subnet-189d3641"
    aws_subnet_public_c_id = "subnet-4490466f" #actually AZ 1d
    aws_subnet_private_a_id = "subnet-4ad3583d"
    aws_subnet_private_b_id = "subnet-1d9d3644"
    aws_subnet_private_c_id = "subnet-4690466d" #actually AZ 1d
    aws_vpc_id = "vpc-27214d42"
    stack_name = "stage-dcos"
    fallback_dns_0 = "10.20.176.4"
    fallback_dns_1 = "10.20.176.20"
    fallback_dns_2 = "10.20.176.36"
}
