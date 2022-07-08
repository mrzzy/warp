#
# WARP
# Box VM Packer Build Sources
#

# vagrant source will auto package a new vagrant box after build.
source "vagrant" "ubuntu" {
  communicator = "ssh"
  provider     = "virtualbox"

  # source box
  source_path = "ubuntu/focal64"
  box_version = "v20220215.1.0"

  # output box
  box_name   = "mrzzy/warp-box${var.image_suffix}"
  output_dir = "build"
}

source "googlecompute" "ubuntu" {
  communicator = "ssh"
  ssh_username = "packer"

  # google project / zone
  project_id  = "mrzzy-sandbox"
  zone        = "asia-southeast1-c" # singapore
  preemptible = true

  # compute engine image as build base
  source_image_family = "ubuntu-minimal-2004-lts"
  source_image        = "ubuntu-minimal-2004-focal-v20220419a"

  # vm image name
  image_name = "warp-box${var.image_suffix}"
}

source "linode" "ubuntu" {
  linode_token = var.linode_token

  communicator = "ssh"
  ssh_username = "root"

  # builder vm
  region        = "ap-south"       # singapore
  instance_type = "g6-dedicated-2" # 2 CPU, 4GB ram

  # build base
  image = "linode/ubuntu20.04"

  # vm image
  image_label       = "warp-box${var.image_suffix}"
  image_description = "Image for bootstrapping a WARP development VM."
}
