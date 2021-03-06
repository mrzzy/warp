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

  required_plugins {
    linode = {
      version = ">= 1.0.1, <1.1"
      source  = "github.com/hashicorp/linode"
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
  sources = concat([
    "source.vagrant.ubuntu",
    "source.googlecompute.ubuntu"
  ], length(var.linode_token) > 0 ? ["source.linode.ubuntu"] : [])

  provisioner "ansible" {
    extra_arguments = [
      "-vv",
      "--extra-vars", local.ansible_vars
    ]
    galaxy_file   = "box/ansible/requirements.yaml"
    playbook_file = "box/ansible/playbook.yaml"

    ansible_env_vars = [
      # config ansible to output human readable logs
      "ANSIBLE_LOAD_CALLBACK_PLUGINS=debug",
      # put ansible tmpdir in tmpfs when provisioning on remote machine
      # to avoid permission issues.
      "ANSIBLE_REMOTE_TMP=/tmp/ansible"
    ]
  }
}
