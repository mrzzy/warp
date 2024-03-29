#
# WARP
# Terraform Deployment: WARP VM on GCP
#

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.22.0"
    }
  }
}

locals {
  warp_disk_id = "warp-disk"
}

data "google_compute_image" "warp_box" {
  name = var.image
}

data "google_compute_network" "sandbox" {
  name = "sandbox"
}

# service account for VM instance - needed to restrict IAM permissions on WARP VM
# as the default service account gives GCP project wide editor permissions.
resource "google_service_account" "warp" {
  account_id   = "warp-vm"
  display_name = "Service account for WARP VM instance(s)."
}

# disk for persistent storage when using the ephemeral development VM
resource "google_compute_disk" "warp_disk" {
  name = "warp-box-disk"
  size = var.disk_size_gb
}

# allocate a static IP for WARP VM as long as its enabled.
resource "google_compute_address" "warp" {
  count = var.enabled ? 1 : 0

  name         = "warp-vm-ip"
  description  = "Static IP for a WARP VM instance(s)."
  network_tier = "STANDARD"
}

# development VM instance
resource "google_compute_instance" "wrap_vm" {
  count        = var.enabled ? 1 : 0
  name         = "warp-box-vm"
  machine_type = var.machine_type
  tags         = var.tags

  # allow WARP VM to be stopped to update attributes such as machine_type.
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      type  = var.disk_type
      image = data.google_compute_image.warp_box.self_link
    }
  }

  attached_disk {
    source = google_compute_disk.warp_disk.self_link
    # accessible via /dev/disk/by-id/google- prefix
    device_name = local.warp_disk_id
  }

  network_interface {
    network = data.google_compute_network.sandbox.self_link
    access_config {
      network_tier = one(google_compute_address.warp).network_tier
      nat_ip       = one(google_compute_address.warp).address
    }
  }

  service_account {
    email = google_service_account.warp.email
    # access control is enforced at the IAM role level
    # https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances#using
    scopes = ["cloud-platform"]
  }

  metadata = {
    # user data is used by cloud-init to provision the system
    user-data = templatefile("${path.module}/templates/cloud_init.yaml", {
      warp_disk_device = "/dev/disk/by-id/google-${local.warp_disk_id}"
      mountpoint       = "/home/mrzzy/disk"
      ttyd_cert_base64 = base64encode(var.web_tls_cert)
      ttyd_key_base64  = base64encode(var.web_tls_key)
    })
    # VM retrieves authorized ssh keys from 'ssh-keys' metadata key only
    block-project-ssh-keys = true
    ssh-keys               = var.ssh_public_key
  }
}
