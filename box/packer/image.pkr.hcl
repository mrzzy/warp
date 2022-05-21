#
# WARP
# Box VM Packer template
#

packer {
  required_version = ">=1.8, <1.9"

  # development tools
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

  # cloud providers
  required_plugins {
    googlecompute = {
      version = ">=1.0.12, <1.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

# vagrant source will auto package a new vagrant box after build.
source "vagrant" "ubuntu" {
  communicator = "ssh"
  provider     = "virtualbox"

  # source box
  source_path = "ubuntu/focal64"
  box_version = "v20220215.1.0"

  # output box
  box_name   = "mrzzy/warp-box"
  output_dir = "build"
}

source "googlecompute" "ubuntu" {
  communicator = "ssh"
  ssh_username = "packer"

  # google project / zone
  project_id  = "mrzzy-sandbox"
  zone        = "asia-southeast1-c"
  preemptible = true

  # compute engine image as build base
  source_image_family = "ubuntu-minimal-2004-lts"
  source_image        = "ubuntu-minimal-2004-v20220419a"

  # TODO(mrzzy): suffix with development (built from laptop), production (built from CI).
  image_name = "warp-box"
}

build {
  sources = [
    "source.vagrant.ubuntu",
    "source.googlecompute.ubuntu"
  ]

  provisioner "ansible" {
    extra_arguments = ["-vv"]
    playbook_file   = "box/ansible/playbook.yaml"
    # by default runs as user running packer,
    # change it to the vagrant user which has passwordless root permissions.
    user = "vagrant"
  }
}
