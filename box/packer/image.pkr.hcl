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

    # config ansible to output human readable logs
    ansible_env_vars = [
      "ANSIBLE_LOAD_CALLBACK_PLUGINS=debug"
    ]
  }
}
