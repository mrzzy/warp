#
# WARP
# Box VM Packer template
#

packer {
  required_version = ">=1.8, <1.9"

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
  box_name   = "mrzzy/warp-box"
  output_dir = "build"
}

build {
  sources = [
    "source.vagrant.ubuntu-focal"
  ]

  provisioner "ansible" {
    playbook_file = "box/ansible/playbook.yaml"
    # by default runs as user running packer,
    # change it to the vagrant user which has passwordless root permissions.
    user = "vagrant"
  }
}
