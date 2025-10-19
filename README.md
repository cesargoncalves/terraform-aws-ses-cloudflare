# AWS SES Cloudflare Terraform module

Terraform module to create AWS SES identity with Cloudflare DNS validation.

## Example

<!-- BEGIN_TF_DOCS -->
```hcl
data "aws_caller_identity" "current" {}

module "sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "6.2.0"

  name = "ses-notifications-${data.aws_caller_identity.current.account_id}"
}

module "ses-cloudflare" {
  source = "../../"

  domain_name   = "example.tld"
  sns_topic_arn = module.sns.topic_arn
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.98.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 5.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.98.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | >= 5.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain to use for SES | `string` | n/a | yes |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | SNS topic for bounce/complaint notifications | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ses_domain_identity_arn"></a> [ses\_domain\_identity\_arn](#output\_ses\_domain\_identity\_arn) | The ARN of the SES domain identity |
<!-- END_TF_DOCS -->
