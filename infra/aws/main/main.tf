terraform {
  required_version = "~> 1.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~>4.1"
    }
  }

  backend "s3" {
    bucket       = "koes-terraform-state"
    key          = "main/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}

locals {
  common_tags = {
    Project     = "KOES"
    Environment = "main"
    ManagedBy   = "terraform"
  }
}

provider "aws" {
  region = var.aws_region
}

