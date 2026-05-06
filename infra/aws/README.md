## GitHub <-> AWS Flow

```

GitHub Actions (OIDC)
        │
        ▼
Assume GitHubActionsOIDCRole (Main Account)
        │
        ├──► Read/Write S3 state bucket     (stays in Main Account)
        ├──► Lock/Unlock state files        (stays in Main Account)
        │
        └──► sts:AssumeRole → target workload account
                    ├── dev:   arn:aws:iam::DEV_ID:role/GitHubActionsCrossAccountDeployRole
                    ├── stage: arn:aws:iam::STAGE_ID:role/GitHubActionsCrossAccountDeployRole
                    └── prod:  arn:aws:iam::PROD_ID:role/GitHubActionsCrossAccountDeployRole

```
