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
  description = "Password to set for accessing WARP VM's web terminal"
  type        = string
  sensitive   = true
  default     = ""
}
