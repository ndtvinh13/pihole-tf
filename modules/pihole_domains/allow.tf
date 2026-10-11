# =============================================================================
# Allow list — add or remove entries here
# =============================================================================
#
# kind = "regex"  → matches domain + all subdomains (use a regex pattern)
# kind = "exact"  → matches one hostname only
#
# Regex example for example.com and *.example.com:
#   domain = "(^|\\.)example\\.com$"
# =============================================================================

locals {
  allow_rules = {
    allow_createa229_uk = {
      domain  = "(^|\\.)createa229\\.uk$"
      kind    = "regex"
      comment = "Allow createa229.uk and *.createa229.uk"
    }
    allow_newrelic_com = {
      domain  = "(^|\\.)newrelic\\.com$"
      kind    = "regex"
      comment = "Allow newrelic.com and *.newrelic.com"
    }
    allow_nr_data_net = {
      domain  = "(^|\\.)nr-data\\.net$"
      kind    = "regex"
      comment = "Allow nr-data.net and *.nr-data.net"
    }
    allow_github_com = {
      domain  = "(^|\\.)github\\.com$"
      kind    = "regex"
      comment = "Allow github.com and *.github.com"
    }
    allow_1passwordservices_com = {
      domain  = "(^|\\.)1passwordservices\\.com$"
      kind    = "regex"
      comment = "Allow 1passwordservices.com and *.1passwordservices.com"
    }
    allow_life360_com = {
      domain  = "(^|\\.)life360\\.com$"
      kind    = "regex"
      comment = "Allow life360.com and *.life360.com"
    }
    allow_infra_api_newrelic_com = {
      domain  = "infra-api.newrelic.com"
      kind    = "exact"
      comment = "Allow infra-api.newrelic.com"
    }
    allow_client_telemetry_us_east_1_amazonaws_com = {
      domain  = "client-telemetry.us-east-1.amazonaws.com"
      kind    = "exact"
      comment = "Allow client-telemetry.us-east-1.amazonaws.com"
    }
    allow_telemetry_n8n_io = {
      domain  = "telemetry.n8n.io"
      kind    = "exact"
      comment = "N8N"
    }
    allow_sentry_sonarr_tv = {
      domain  = "sentry.sonarr.tv"
      kind    = "exact"
      comment = "Sonarr App"
    }
  }
}

resource "pihole_domain" "allow" {
  for_each = local.allow_rules

  domain  = each.value.domain
  type    = "allow"
  kind    = each.value.kind
  enabled = true
  comment = each.value.comment
}
