#
# WARP
# Box VM Packer Build Sources
#

# vagrant source will auto package a new vagrant box after build.
source "vagrant" "ubuntu" {
  communicator = "ssh"
  provider     = "virtualbox"

  # source box
  source_path = "ubuntu/jammy64"
  box_version = "v20221101.1.0"

  # output box
  box_name   = "mrzzy/warp-box${var.image_suffix}"
  output_dir = "build"
}

source "googlecompute" "ubuntu" {
  communicator = "ssh"
  ssh_username = "packer"

  # google cloud build environment
  project_id  = "mrzzy-sandbox"
  zone        = "asia-southeast1-c" # singapore
  preemptible = true

  # compute engine image as build base
  source_image_family = "ubuntu-minimal-2004-lts"
  source_image        = "ubuntu-minimal-2004-focal-v20220419a"

  # vm image name
  image_name = "warp-box${var.image_suffix}"
}
