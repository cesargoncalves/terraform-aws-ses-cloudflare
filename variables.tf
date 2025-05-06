variable "domain_name" {
  description = "Domain to use for SES"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic for bounce/complaint notifications"
  type        = string
}
