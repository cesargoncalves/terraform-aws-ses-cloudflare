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
