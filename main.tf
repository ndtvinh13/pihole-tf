terraform {
  # State Storage
  backend "s3" {
    bucket       = "my-homelab-tofu-state-bucket"
    key          = "pihole/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  # Providers
  required_providers {
    pihole = {
      source  = "registry.terraform.io/dklesev/pihole"
      version = "~> 1.0"
    }
  }
}

provider "pihole" {
  url      = var.pihole_host
  password = var.pihole_password
}

resource "pihole_local_dns" "example" {
  hostname = "test.com"
  ip       = "192.168.1.1"
}

resource "pihole_local_dns" "example2" {
  hostname = "test2.com"
  ip       = "192.168.1.2"
}

resource "pihole_local_dns" "example3" {
  hostname = "test3.com"
  ip       = "192.168.1.3"
}
