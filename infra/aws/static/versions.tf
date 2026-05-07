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

}

provider "aws" {
  region  = var.aws_region
  profile = "koes-dev"

}
