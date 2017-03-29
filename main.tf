provider "aws" {
  region     = "us-east-1"
}

variable "environment" {
  type = "string"
  default = "dev"
}

terraform {
  backend "s3" {
    bucket = "cnry-nonprod-terraform-state"
    key    = "dcos/dev/main.tfstate"
    region = "us-east-1"
  }
}
