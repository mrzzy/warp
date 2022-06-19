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
  description = "Login password for WARP VM's web terminal."
  type        = string
  sensitive   = true
  default     = ""
}

variable "tls_letsencrypt_production" {
  description = <<-EOF
    Whether to obtain a test certificate from the staging Lets Encrypt server (false)
    or obtain a trusted certificate from the production Lets Encrypt server (true)

    Defaults to false to avoid hitting Lets Encrypt production servers's rate limits.
  EOF
  type        = bool
  default     = false
}
