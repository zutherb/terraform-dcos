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
    env = "dev"
    aws_region = "us-east-1"
    aws_subnet_public_a_id = "subnet-aa78efdd"
    aws_subnet_private_a_id = "subnet-a978efde"
    aws_vpc_id = "vpc-9c7702f9"
    stack_name = "dev-dcos"
}
