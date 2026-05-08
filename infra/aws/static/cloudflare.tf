data "cloudflare_ip_ranges" "this" {}

locals {
  cloudflare_ips = concat(
    data.cloudflare_ip_ranges.this.ipv4_cidrs,
    data.cloudflare_ip_ranges.this.ipv6_cidrs
  )
}

data "cloudflare_zone" "koes_site" {
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_dns_record" "koes_static" {
  zone_id = data.cloudflare_zone.koes_site.zone_id
  name    = "static"
  type    = "CNAME"
  content = aws_s3_bucket_website_configuration.koes_static.website_endpoint
  ttl     = 1
  proxied = true
}

resource "cloudflare_ruleset" "security_headers" {
  zone_id = var.cloudflare_zone_id
  name    = "security-headers"
  kind    = "zone"
  phase   = "http_response_headers_transform"

  rules = [{
    ref         = "security_headers"
    description = "Add security headers"
    expression  = "true"
    action      = "rewrite"
    enabled     = true

    action_parameters = {
      headers = {
        "Strict-Transport-Security" = {
          operation = "set"
          value     = "max-age=63072000; includeSubDomains; preload"
        }

        "X-Content-Type-Options" = {
          operation = "set"
          value     = "nosniff"
        }

        "X-Frame-Options" = {
          operation = "set"
          value     = "DENY"
        }

        "Referrer-Policy" = {
          operation = "set"
          value     = "strict-origin-when-cross-origin"
        }

        "Permissions-Policy" = {
          operation = "set"
          value     = "geolocation=()"
        }

        "Content-Security-Policy" = {
          operation = "set"
          value     = "default-src 'self'; img-src 'self' data: https:; script-src 'self' 'unsafe-inline' https:; style-src 'self' 'unsafe-inline' https:; font-src 'self' data: https:; connect-src 'self' https:; frame-ancestors 'none'; base-uri 'self'; form-action 'self';"
        }

        "X-Powered-By" = {
          operation = "remove"
        }
      }
    }
  }]
}
