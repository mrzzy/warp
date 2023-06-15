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
      version = "< 1.2"
      source  = "github.com/hashicorp/ansible"
    }
  }

  # cloud providers
  required_plugins {
    googlecompute = {
      version = "< 1.2"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

locals {
  # compile ansible vars into VAR1=VALUE1 VAR2=VALUE2 format
  ansible_vars = join(" ",
    concat(
      ["devbox_minimize_storage=true"],
      length(var.web_term_password) > 0 ? ["devbox_ttyd_password=${var.web_term_password}"] : []
    )
  )
}

build {
  sources = [
    "source.vagrant.ubuntu_vm",
    "source.googlecompute.ubuntu_gce"
  ]

  provisioner "ansible" {
    extra_arguments = [
      "-vv",
      "--extra-vars", local.ansible_vars
    ]
    galaxy_file   = "requirements.yaml"
    playbook_file = var.ansible_playbook

    ansible_env_vars = [
      # config ansible to output human readable logs
      "ANSIBLE_LOAD_CALLBACK_PLUGINS=debug",
    ]

    # override user used to provision as ansible's become user escalation relies on it
    override = {
      ubuntu_vm = {
        user = "vagrant"
      }

      ubuntu_gce = {
        user = "packer"
      }
    }
  }
}
