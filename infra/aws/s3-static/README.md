# S3 bucket for hostings apps/static
```

Workload Accounts
├── dev
│   ├── IAM Role: GitHubActionsCrossAccountDeployRole
│   └── S3 Bucket: koes-static (static website hosting)
├── stage → IAM Role: GitHubActionsCrossAccountDeployRole
└── prod  → IAM Role: GitHubActionsCrossAccountDeployRole

```
