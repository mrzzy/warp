#
# WARP
# Box VM Packer template variables
#

variable "image_suffix" {
  description = "Suffix to attach to the built image's name"
  type        = string
  default     = ""
}

variable "web_term_password" {
  description = <<-EOF
    Login password for WARP VM's web terminal. If left unspecified, WARP VM's
    web terminal will be disabled for security.
  EOF
  type        = string
  sensitive   = true
  default     = ""
}

variable "linode_token" {
  description = <<-EOF
    Access token used to authenticate with Linode Cloud. If left unspecified,
    disables the Linode Packer Builder.
  EOF
  type        = string
  sensitive   = true
  default     = ""
}
