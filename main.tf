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
      source  = "dklesev/pihole" #"ryanwholey/pihole"
      version = "~> 1.0" #"~> 0.2.0" # Use the v5-compatible provider
    }
  }
}

# Terraform provider configuration
provider "pihole" {
  url      = var.pihole_host
  password = var.pihole_password
}

# ---------- Terraform resources configuration ----------
# Test DNS record
resource "pihole_dns_record" "example" {
  domain = "test.com"
  ip     = "192.168.1.1"
}

