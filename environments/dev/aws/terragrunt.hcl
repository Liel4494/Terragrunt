terraform {
  source = "../../../terraform-modules/aws/ec2-instance"
}

inputs = {
  region = "eu-west-1"
  ami = get_env("ami_dev")
  instance_type = "t2.micro"
  name = "Amazon_Linux_Dev"
  env = "dev"
}