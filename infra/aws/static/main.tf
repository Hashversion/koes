locals {
  common_tags = {
    Project     = "KOES"
    app         = "static"
    Environment = "Development"
    ManagedBy   = "Terraform"
    Component   = "static-site"
    Repository  = "hashversion/koes"
  }

}
