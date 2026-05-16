terraform {
  required_version = "~> 1.15.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.45.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.19.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.3"
    }
  }

  backend "s3" {
    bucket       = "koes-terraform-state"
    key          = "dev/static/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }

}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.dev_account_id}:role/GitHubActionsCrossAccountDeployRole"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
