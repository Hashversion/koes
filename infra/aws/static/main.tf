locals {
  common_tags = {
    Project            = "KOES"
    app                = "static"
    Environment        = "dev"
    ManagedBy          = "terraform"
    Component          = "static-site"
    Repository         = "hashversion/koes"
    DataClassification = "public"
  }

}
