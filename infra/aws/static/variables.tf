
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "main_account_id" {
  type = string
}

variable "dev_account_id" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

