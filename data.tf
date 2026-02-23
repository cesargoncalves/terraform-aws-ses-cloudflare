data "aws_region" "current" {}

data "cloudflare_zone" "this" {
  filter = {
    name = var.domain_name
  }
}
