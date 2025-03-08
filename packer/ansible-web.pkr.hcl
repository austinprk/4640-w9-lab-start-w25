# Reference: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/packer
packer {
  required_plugins {
    ansible = {
      version = "~> 1.1.2"
      source = "github.com/hashicorp/ansible"
    }

    amazon = {
      version = "~> 1.3"
      source = "github.com/hashicorp/amazon"
    }
  }
}

# Reference: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/source
source "amazon-ebs" "ubuntu" {
  ami_name = "packer-ansible-nginx"
  instance_type = "t2.micro"
  region = "us-west-2"

  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] 
	}
  ssh_username = "${var.ssh_username}"
}

# Reference: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
build {
  name = "packer-ansible-nginx"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

    provisioner "ansible" {
      playbook_file = "../ansible/playbook.yml"
      user = "${var.ssh_username}"
   
      ansible_env_vars = [
        "ANSIBLE_HOST_KEY_CHECKING=False"
        ]
    }
}
