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
      source  = "registry.terraform.io/dklesev/pihole"
      version = "~> 1.0" # Compatible with Pi-hole v6
    }
  }
}

# Terraform provider configuration
provider "pihole" {
  url      = var.pihole_host
  password = var.pihole_password
}



# ---------- Terraform resources configuration ----------




## ---------- Local DNS ----------
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

#Test3 local DNS A record
resource "pihole_local_dns" "example3" {
  hostname = "test3.com"
  ip       = "192.168.1.3"
}





## ---------- Regex Deny ----------
resource "pihole_domain" "allow_test_com" {
  domain  = "(^|\\.)examptest\\.com$"
  type    = "deny"
  kind    = "regex"
  enabled = true
  comment = "Allow github.com and *.github.com"
}

## ---------- Regex Allow ----------
resource "pihole_domain" "allow_createa229_uk" {
  domain  = "(^|\\.)createa229\\.uk$"
  type    = "allow"
  kind    = "regex"
  enabled = true
  comment = "Allow createa229.uk and *.createa229.uk"
}