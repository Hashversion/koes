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

variable "github_actions_iam_role_name" {
  description = "Name of IAM role for GitHub OIDC"
  type        = string
  default     = "GitHubActionsOIDCRole"
}

variable "cross_account_role_name" {
  description = "Name of the cross-account deployment role in target accounts"
  type        = string
  default     = "GitHubActionsCrossAccountDeployRole"
}

variable "env_account_ids" {
  description = "Map of environment names to AWS account IDs"
  type        = map(string)
  sensitive   = true

  validation {
    condition = alltrue([
      for id in values(var.env_account_ids) : can(regex("^\\d{12}$", id))
    ])
    error_message = "Each AWS account ID must be exactly 12 digits."
  }
}


variable "github_repo_owner" {
  description = "GitHub repository owner or username"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub repository name"
  type        = string
}
