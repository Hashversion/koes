data "tls_certificate" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = data.tls_certificate.github_oidc.url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_oidc.certificates[0].sha1_fingerprint]

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = "GitHub Actions OIDC Provider"
  })
}

# Policy for managing infrastructure resources (S3, IAM, OIDC)
data "aws_iam_policy_document" "github_actions_infrastructure" {
  # Full S3 access for Terraform state bucket
  statement {
    sid    = "S3FullBucketAccess"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}",
      "arn:aws:s3:::${var.terraform_state_bucket}/*"
    ]
  }

  # IAM OIDC Provider management
  statement {
    sid    = "IAMOIDCProviderManagement"
    effect = "Allow"
    actions = [
      "iam:CreateOpenIDConnectProvider",
      "iam:GetOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:ListOpenIDConnectProviders",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider"
    ]
    resources = [
      "arn:aws:iam::*:oidc-provider/token.actions.githubusercontent.com"
    ]
  }

  # IAM Policy management
  statement {
    sid    = "IAMPolicyManagement"
    effect = "Allow"
    actions = [
      "iam:CreatePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:DeletePolicy",
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]
    resources = [
      "arn:aws:iam::*:policy/${var.github_actions_iam_role_name}-deployment-policy",
      "arn:aws:iam::*:policy/${var.github_actions_iam_role_name}-infrastructure-policy"
    ]
  }

  # IAM Role management
  statement {
    sid    = "IAMRoleManagement"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:GetRole",
      "iam:UpdateRole",
      "iam:DeleteRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:GetRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListRolePolicies",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:TagRole",
      "iam:UntagRole"
    ]
    resources = [
      "arn:aws:iam::*:role/${var.github_actions_iam_role_name}"
    ]
  }

  # Cross-account deployment access
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

resource "aws_iam_policy" "github_actions_infrastructure" {
  name        = "${var.github_actions_iam_role_name}-infrastructure-policy"
  description = "Policy for GitHub Actions to manage infrastructure resources (S3, IAM, OIDC)"
  policy      = data.aws_iam_policy_document.github_actions_infrastructure.json
  tags = merge(local.common_tags, {
    Name = "GitHub Actions Infrastructure Policy"
  })
}


resource "aws_iam_role" "github_actions_oidc" {
  name        = var.github_actions_iam_role_name
  description = "IAM role for GitHub Actions OIDC authentication and cross-account deployments"

  lifecycle {
    prevent_destroy = true
  }

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

resource "aws_iam_role_policy_attachment" "github_actions_infrastructure" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = aws_iam_policy.github_actions_infrastructure.arn
}

