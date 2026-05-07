resource "aws_s3_bucket" "koes_static" {
  bucket = var.s3_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.common_tags)
}

resource "aws_s3_bucket_versioning" "koes_static" {
  bucket = aws_s3_bucket.koes_static.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "koes_static" {
  bucket = aws_s3_bucket.koes_static.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }

}


resource "aws_s3_bucket_lifecycle_configuration" "koes_static" {
  bucket = aws_s3_bucket.koes_static.id

  rule {
    id     = "Manage Next.js site versions"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days           = 90
      newer_noncurrent_versions = 5
    }
  }
}

resource "aws_s3_bucket_website_configuration" "koes_static" {
  bucket = aws_s3_bucket.koes_static.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "koes_static" {
  bucket = aws_s3_bucket.koes_static.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}


resource "aws_s3_bucket_policy" "cloudflare_ips_only" {
  bucket = aws_s3_bucket.koes_static.id
  policy = jsonencode({
    sid       = "PublicReadGetObject"
    effect    = "allow"
    principal = "*"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.koes_static.arn}/*",
    ]
    condition = {
      IpAddress = {
        "aws:SourceIp" = local.cloudflare_ips
      }
    }
    }
  )
}

