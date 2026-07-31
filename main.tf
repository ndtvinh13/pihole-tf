terraform {
  # Terraform state backend configuration
  backend "s3" {
    bucket       = "my-homelab-tofu-state-bucket"
    key          = "pihole/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  # Terraform providers configuration
  required_providers {
    pihole = {
      source  = "ryanwholey/pihole"
      version = "~> 0.2.0" # Use the v5-compatible provider
    }
  }
}

# Terraform provider configuration
provider "pihole" {
  url      = var.pihole_host
  password = var.pihole_password
}

# ---------- Terraform resources configuration ----------
# Test local DNS A record
resource "pihole_local_dns" "example" {
  hostname = "test.com"
  ip       = "192.168.1.1"
}

# Test2 local DNS A record
resource "pihole_local_dns" "example2" {
  hostname = "test2.com"
  ip       = "192.168.1.2"
}

