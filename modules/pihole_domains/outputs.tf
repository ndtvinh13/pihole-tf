output "allow_domains" {
  description = "Allow list pihole_domain resources"
  value       = pihole_domain.allow
}

output "deny_domains" {
  description = "Deny list pihole_domain resources"
  value       = pihole_domain.deny
}
