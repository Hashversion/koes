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

data "aws_iam_policy_document" "github_actions_deployment" {
  statement {
    sid    = "TerraformStateObjectAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${var.terraform_state_bucket}/*"]
  }

  statement {
    sid    = "TerraformStateBucketAccess"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning"
    ]
    resources = ["arn:aws:s3:::${var.terraform_state_bucket}"]
  }

  statement {
    sid     = "CrossAccountDeploymentAccess"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      for account_id in values(var.env_account_ids) :
      "arn:aws:iam::${account_id}:role/${var.cross_account_role_name}"
    ]
  }
}

resource "aws_iam_policy" "github_actions_deployment" {
  name        = "${var.github_actions_iam_role_name}-deployment-policy"
  description = "Policy for GitHub Actions to manage Terraform state and assume cross-account deployment roles"
  policy      = data.aws_iam_policy_document.github_actions_deployment.json
  tags = merge(local.common_tags, {
    Name = "GitHub Actions Deployment Policy"
  })
}

resource "aws_iam_role" "github_actions_oidc" {
  name        = var.github_actions_iam_role_name
  description = "IAM role for GitHub Actions OIDC authentication and cross-account deployments"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              /**
              ⚠️ CAUTION: be careful here :: anyone can trigger this if not configured properly.
               ensure repo_owner and repo_name are correctly set to restrict access to your specific repository
             */
              "repo:${var.github_repo_owner}/${var.github_repo_name}:*",
            ]
          }
        }
      }
    ]
  })


  tags = merge(local.common_tags, {
    Name = "GitHub Actions OIDC Role"
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_deployment" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = aws_iam_policy.github_actions_deployment.arn
}
