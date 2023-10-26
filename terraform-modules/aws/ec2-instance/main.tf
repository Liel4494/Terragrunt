provider "aws" {
  region = var.region
}

#If default_vpc not created in the region
#resource "aws_default_vpc" "default" {
#  tags = {
#    Name = "Default VPC"
#  }
#}

resource "aws_instance" "terragrunt-instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "tfe-base"
  tags = {
    Name = var.name
    Env = var.env
  }
}