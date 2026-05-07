resource "aws_iam_role" "cross_account_deploy" {
  name = "GitHubActionsCrossAccountDeployRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::${var.main_account_id}:root"
      },
      Action = "sts:AssumeRole",
    }],
    }
  )
  tags = merge(local.common_tags)

}

data "aws_iam_policy" "admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.cross_account_deploy.name
  policy_arn = data.aws_iam_policy.admin.arn
}
