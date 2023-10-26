packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  timestamp    = formatdate("hh-mm-ss-DD-MM-YYYY", timestamp())
  prod_json    = "prod-ubuntu-manifest-${local.timestamp}.json"
  dev_json     = "dev-amazon_linux_2023-manifest-${local.timestamp}.json"
  staging_json = "staging-winServer2022-manifest-${local.timestamp}.json"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu22.04_64Bit-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      image-id            = "ami-01dd271720c1ba44f"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    #    To check ami owner, use this aws cli command:
    #    aws ec2 describe-images --region eu-west-1 --image-ids ami-XXXXXXXXXXXXXXXXX | grep OwnerId
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

source "amazon-ebs" "amazon_linux_2023" {
  ami_name      = "amazon_linux_2023-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      image-id            = "ami-0b9fd8b55a6e3c9d5"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    #    To check ami owner, use this aws cli command:
    #    aws ec2 describe-images --region eu-west-1 --image-ids ami-XXXXXXXXXXXXXXXXX | grep OwnerId
    owners      = ["137112412989"]
  }
  ssh_username = "ec2-user"
}

source "amazon-ebs" "winServer2022" {
  ami_name      = "winServer2022-${local.timestamp}"
  instance_type = "t2.large"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      image-id            = "ami-04c320a393da4b1ba"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    #    To check ami owner, use this aws cli command:
    #    aws ec2 describe-images --region eu-west-1 --image-ids ami-XXXXXXXXXXXXXXXXX | grep OwnerId
    owners      = ["801119661308"]
  }

  ssh_username   = "Administrator"
  ssh_password   = "SuperS3cr3t!!!!"

  # Install SSH and set Administrator password.
  user_data_file = "./packer/bootstrap_win.txt"

  #  winrm_username = "Administrator"
  #  winrm_password = "SuperS3cr3t!!!!"
}

build {
  name    = "prodBuild"
  sources = [
    "source.amazon-ebs.ubuntu",
  ]

  provisioner "ansible" {
    playbook_file = "./packer/ansible_playbooks/ubuntu-playbook.yml"
  }

  post-processors {
    post-processor "manifest" {
      output     = "./packer/${local.prod_json}"
      strip_path = false
    }
  }
}

build {
  name    = "devBuild"
  sources = [
    "source.amazon-ebs.amazon_linux_2023"
  ]

  provisioner "ansible" {
    playbook_file = "./packer/ansible_playbooks/awsLinux-playbook.yml"
  }

  post-processors {
    post-processor "manifest" {
      output     = "./packer/${local.dev_json}"
      strip_path = false
    }
  }
}

build {
  name    = "stagingBuild"
  sources = [
    "source.amazon-ebs.winServer2022"
  ]

  provisioner "powershell" {
    script = "./packer/Chocolatey.ps1"
  }

  #  provisioner "ansible" {
  #      playbook_file = "./ansible_playbooks/windows-playbook.yml"
  #      user            = "Administrator"
  #      use_proxy       = false
  #      extra_arguments = [
  #        "-e",
  #        "ansible_winrm_server_cert_validation=ignore"
  #      ]
  #    }

  post-processors {
    post-processor "manifest" {
      output     = "./packer/${local.staging_json}"
      strip_path = false
    }
  }
}