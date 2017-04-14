variable "ssh_public_key" {
  description = "SSH public key to give SSH access"
  default = "brohenry-dev"
}

variable "env" {}

variable "consul_datacenter" {}

variable "aws_region" {
  description = "AWS Region to launch configuration in"
}

variable "aws_subnet_public_a_id" {}
variable "aws_subnet_public_b_id" {}
variable "aws_subnet_public_c_id" {}

variable "aws_subnet_private_a_id" {}
variable "aws_subnet_private_b_id" {}
variable "aws_subnet_private_c_id" {}

variable "fallback_dns_0" {}
variable "fallback_dns_1" {}
variable "fallback_dns_2" {}

variable "aws_vpc_id" {}
variable "aws_key_pair_name" {
  default = "brohenry-dev"
}

###############################
### CONFIGURABLE PARAMETERS ###
###############################

variable "stack_name" {
  description = "DCOS stack name"
}

variable "elb_version" {
  description = "Loadbalancer Version"
  default = ""
}

variable "slave_instance_count" {
  description = "Number of slave nodes to launch"
  default = 5
}

variable "public_slave_instance_count" {
  description = "Number of public slave nodes to launch"
  default = 1
}

variable "admin_location" {
  description = "The IP range to whitelist for admin access. Must be a valid CIDR."
  default = "0.0.0.0/0"
}

##################
### PARAMETERS ###
##################

variable "aws_availability_zones" {
  description = "AWS Availability zones"
  default = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
}

variable "dcos_gateway_instance_type" {
  description = "Default instance type for masters"
  default = "m3.medium"
}

variable "vpn_instance_type" {
  description = "Default instance type for masters"
  default = "m3.medium"
}

variable "master_instance_type" {
  description = "Default instance type for masters"
  default = "m3.xlarge"
}

variable "slave_instance_type" {
  description = "Default instance type for slaves"
  default = "m3.xlarge"
}

variable "public_slave_instance_type" {
  description = "Default instance type for public slaves"
  default = "m3.xlarge"
}

variable "vpc_subnet_range" {
  description = "The IP range of the VPC subnet"
  default = "10.0.0.0/16"
}

variable "master_instance_count" {
  description = "Amount of requested Masters"
  default = 3
  #when override number of instances please use an other cluster_packages (see below)
}

variable "private_subnet_range" {
  description = "Private Subnet IP range"
  default = "10.0.0.0/22"
}

variable "public_subnet_range" {
  description = "Public Subnet IP range"
  default = "10.0.4.0/24"
}

variable "master_subnet_range" {
  description = "Master Subnet IP range"
  default = "10.0.5.0/24"
}

variable "fallback_dns" {
  description = "Fallback DNS IP"
  default = "169.254.169.253"
}

variable "coreos_amis" {
  description = "AMI for CoreOS machine"
  default = {
    ap-northeast-1  = "ami-965899f7"
    ap-southeast-1  = "ami-3120fe52"
    ap-southeast-2  = "ami-b1291dd2"
    eu-central-1    = "ami-3ae31555"
    eu-west-1       = "ami-b7cba3c4"
    sa-east-1       = "ami-61e3750d"
    us-east-1       = "ami-6d138f7a"
    us-gov-west-1   = "ami-b712acd6"
    us-west-1       = "ami-ee57148e"
    us-west-2       = "ami-dc6ba3bc"
  }
}

variable "nat_amis" {
  description = "AMI for Amazon NAT machine"
  default = {
    ap-northeast-1  = "ami-55c29e54"
    ap-southeast-1  = "ami-b082dae2"
    ap-southeast-2  = "ami-996402a3"
    eu-central-1    = "ami-204c7a3d"
    eu-west-1       = "ami-3760b040"
    sa-east-1       = "ami-b972dba4"
    us-east-1       = "ami-4c9e4b24"
    us-gov-west-1   = "ami-e8ab1489"
    us-west-1       = "ami-2b2b296e"
    us-west-2       = "ami-bb69128b"
  }
}

variable "dns_domainnames" {
  description = "DNS Names for regions"
  default = {
    ap-northeast-1  = "compute.internal"
    ap-southeast-1  = "compute.internal"
    ap-southeast-2  = "compute.internal"
    eu-central-1    = "compute.internal"
    eu-west-1       = "compute.internal"
    eu-west-2       = "compute.internal"
    sa-east-1       = "compute.internal"
    us-east-1       = "ec2.internal"
    us-gov-west-1   = "compute.internal"
    us-west-1       = "compute.internal"
    us-west-2       = "compute.internal"
  }
}

variable "ubuntu_amis" {
  description = "Ubuntu AMIs for regions"
  default = {
    ap-northeast-1  = "ami-2f4d3148"
    ap-southeast-1  = "ami-f6953e95"
    ap-southeast-2  = "ami-f5717596"
    eu-central-1    = "ami-59ed2136"
    eu-west-1       = "ami-ddfbd1ae"
    sa-east-1       = "ami-4a79e326"
    us-east-1       = "ami-43c92455"
    us-west-1       = "ami-eb94c78b"
    us-west-2       = "ami-e9873a89"
  }
}

variable "authentication_enabled" {
  description = "authentication_enabled"
  default = true
}

variable "dcos_base_download_url" {
  description = "base url that is used to download the dcos"
  default = "https://downloads.dcos.io/dcos/stable"
}

variable "bootstrap_id" {
  description = "bootstrap id that is used to download the bootstrap files"
  default = "5df43052907c021eeb5de145419a3da1898c58a5"
}

//variable "cluster_packages" {
//  description = "cluster packages for single master setup"
//  default = <<EOF
//    [
//      "dcos-config--setup_2e94e4f724600dd9c9b3092f28f2b89ad9005673",
//      "dcos-metadata--setup_2e94e4f724600dd9c9b3092f28f2b89ad9005673"
//    ]EOF
//}

variable "cluster_packages" {
  description = "cluster packages for multi master setup"
  default = <<EOF
    [
      "dcos-config--setup_3005760370194d0d05886172ae2d3d74c9cfbc89",
      "dcos-metadata--setup_3005760370194d0d05886172ae2d3d74c9cfbc89"
    ]EOF
}
