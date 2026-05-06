# Main AWS Account

```

Main Account (Tooling / Platform)
├── GitHub Actions OIDC Provider
├── IAM Role: GitHubActionsOIDCRole (trusted by OIDC)
├── S3 Bucket: koes-terraform-state
│   ├── main/terraform.tfstate                ← main account infra itself
│   │
│   ├── dev/<app-name>/terraform.tfstate   ← state files <env/app/terraform.tfstate>
│   ├── dev/static/terraform.tfstate
│   ├── stage/static/terraform.tfstate
│   └── prod/static/terraform.tfstate


Workload Accounts
├── dev   → IAM Role: GitHubActionsCrossAccountDeployRole
├── stage → IAM Role: GitHubActionsCrossAccountDeployRole
└── prod  → IAM Role: GitHubActionsCrossAccountDeployRole

```
