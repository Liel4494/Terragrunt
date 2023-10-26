output "public_ip" {
  value = aws_instance.terragrunt-instance.public_ip
}