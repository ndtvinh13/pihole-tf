# =============================================================================
# Deny list — add or remove entries here
# =============================================================================
#
# kind = "regex"  → matches domain + all subdomains (use a regex pattern)
# kind = "exact"  → matches one hostname only
#
# Regex example for example.com and *.example.com:
#   domain = "(^|\\.)example\\.com$"
# =============================================================================

locals {
  deny_rules = {
    deny_examptest_com = {
      domain  = "(^|\\.)examptest\\.com$"
      kind    = "regex"
      comment = "Deny examptest.com and *.examptest.com"
    }
  }
}

resource "pihole_domain" "deny" {
  for_each = local.deny_rules

  domain  = each.value.domain
  type    = "deny"
  kind    = each.value.kind
  enabled = true
  comment = each.value.comment
}
