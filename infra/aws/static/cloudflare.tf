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
