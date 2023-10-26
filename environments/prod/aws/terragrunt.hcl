terraform {
  source = "../../../terraform-modules/aws/ec2-instance"
}

inputs = {
  region = "eu-west-1"
  ami = get_env("ami_prod")
  instance_type = "t2.micro"
  name = "ubuntu22.04_prod"
  env = "prod"
}