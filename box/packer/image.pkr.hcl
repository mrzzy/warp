#
# WARP
# Box VM Packer template
#

packer {
  required_version = ">=1.7.10, <1.8"

  required_plugins {
    vagrant = {
      version = ">=1.0.1, <1.1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
  required_plugins {
    ansible = {
      version = ">=1.0.1, <1.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# vagrant source will auto package a new vagrant box after build.
source "vagrant" "ubuntu-focal" {
  communicator = "ssh"
  provider     = "virtualbox"

  # source box
  source_path = "ubuntu/focal64"
  box_version = "v20220215.1.0"

  # output box
  skip_package = true
  box_name     = "mrzzy/warp-box"
}

build {
  sources = [
    "source.vagrant.ubuntu-focal"
  ]

  provisioner "ansible" {
    playbook_file = "ansible/playbook.yaml"
  }
}

