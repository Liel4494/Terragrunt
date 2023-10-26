terraform {
  source = "../../../terraform-modules/aws/ec2-instance"
}

inputs = {
  region = "eu-west-1"
  ami = get_env("ami_staging")
  instance_type = "t2.micro"
  name = "winServer22_staging"
  env = "staging"
}