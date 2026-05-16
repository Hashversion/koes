terraform {
<<<<<<< HEAD
  required_version = "~> 1.15.2"
=======
  required_version = "~> 1.12"
>>>>>>> parent of b36c005 (chore(deps): update terraform hashicorp/terraform to ~> 1.15 (#8))

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.45.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.3"
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

data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.aws_region
}

