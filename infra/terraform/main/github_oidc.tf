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

# Policy for managing infrastructure resources (S3, IAM, OIDC)
data "aws_iam_policy_document" "github_actions_infrastructure" {
  # S3 bucket management for Terraform state bucket
  statement {
    sid    = "S3BucketManagement"
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketEncryption",
      "s3:PutBucketEncryption",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:ListBucket",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:GetBucketAcl",
      "s3:PutBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}",
      "arn:aws:s3:::${var.terraform_state_bucket}/*"
    ]
  }

  # S3 object access for Terraform state files
  statement {
    sid    = "TerraformStateObjectAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl"
    ]
    resources = ["arn:aws:s3:::${var.terraform_state_bucket}/*"]
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

# Policy for deployment operations (used after infrastructure is created)
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

resource "aws_iam_policy" "github_actions_infrastructure" {
  name        = "${var.github_actions_iam_role_name}-infrastructure-policy"
  description = "Policy for GitHub Actions to manage infrastructure resources (S3, IAM, OIDC)"
  policy      = data.aws_iam_policy_document.github_actions_infrastructure.json
  tags = merge(local.common_tags, {
    Name = "GitHub Actions Infrastructure Policy"
  })
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

resource "aws_iam_role_policy_attachment" "github_actions_infrastructure" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = aws_iam_policy.github_actions_infrastructure.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_deployment" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = aws_iam_policy.github_actions_deployment.arn
}
