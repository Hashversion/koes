variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "sso_profile" {
  description = "AWS CLI SSO profile to use"
  type        = string
}

variable "terraform_state_bucket" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  sensitive   = true
}
