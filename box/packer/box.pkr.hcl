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

}

# vagrant source will auto package a new vagrant box after build.
source "vagrant" "ubuntu-focal" {
  communicator = "ssh"
  provider     = "virtualbox"
  source_path  = "ubuntu/focal64"
}

build {
  sources = [
    "source.vagrant.ubuntu-focal"
  ]
}
