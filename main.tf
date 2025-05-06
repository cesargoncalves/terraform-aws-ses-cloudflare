resource "aws_ses_domain_identity" "this" {
  domain = var.domain_name
}

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

resource "aws_ses_domain_mail_from" "this" {
  domain           = aws_ses_domain_identity.this.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.this.domain}"
}

resource "cloudflare_dns_record" "verification" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.this.domain}"
  content = aws_ses_domain_identity.this.verification_token
  type    = "TXT"
  ttl     = "600"
}

resource "cloudflare_dns_record" "mx" {
  zone_id  = data.cloudflare_zone.this.zone_id
  name     = aws_ses_domain_identity.this.domain
  content  = "inbound-smtp.eu-west-1.amazonaws.com"
  priority = "10"
  type     = "MX"
  ttl      = "600"
}

resource "cloudflare_dns_record" "dkim_records" {
  count = 3

  zone_id = data.cloudflare_zone.this.zone_id
  name    = "${aws_ses_domain_dkim.this.dkim_tokens[count.index]}._domainkey.${aws_ses_domain_identity.this.domain}"
  content = "${aws_ses_domain_dkim.this.dkim_tokens[count.index]}.dkim.amazonses.com"
  type    = "CNAME"
  ttl     = "600"
}

resource "cloudflare_dns_record" "mail_from_mx" {
  zone_id  = data.cloudflare_zone.this.zone_id
  name     = aws_ses_domain_mail_from.this.mail_from_domain
  content  = "feedback-smtp.eu-west-1.amazonses.com"
  priority = 10
  type     = "MX"
  ttl      = "600"
}

resource "cloudflare_dns_record" "mail_from_mx_txt" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = aws_ses_domain_mail_from.this.mail_from_domain
  content = "v=spf1 include:amazonses.com ~all"
  type    = "TXT"
  ttl     = "600"
}

resource "cloudflare_dns_record" "dmarc" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "_dmarc.${aws_ses_domain_identity.this.domain}"
  content = "v=DMARC1; p=none;"
  type    = "TXT"
  ttl     = "600"
}

resource "aws_ses_identity_notification_topic" "bounces_and_complaints" {
  for_each = toset(["Bounce", "Complaint"])

  topic_arn                = var.sns_topic_arn
  notification_type        = each.key
  identity                 = aws_ses_domain_identity.this.domain
  include_original_headers = true
}
