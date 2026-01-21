data "tls_certificate" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = data.tls_certificate.github_oidc.url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_oidc.certificates[0].sha1_fingerprint]


  tags = merge(local.common_tags, {
    Name = "GitHub Actions OIDC Provider"
  })
}
