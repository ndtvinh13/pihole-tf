variable "pihole_password" {
  type        = string
  description = "The password for the Pi-hole API"
  sensitive   = true
}

variable "pihole_host" {
  type        = string
  description = "The host for the Pi-hole API"
  default     = "http://192.168.0.206:8800/admin/"
}