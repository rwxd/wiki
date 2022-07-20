# Gitleak

## Scan current git repository

```bash
docker run -v "$PWD":/path ghcr.io/zricethezav/gitleaks:v8.8.12 detect -f json -r "/path/report-secrets.json" --source="/path"
```

Extract unique secrets to `extracted-secrets`

```bash
cat report-secrets.json | jq -n -r 'inputs[].Secret' | uniq -u > extracted-secrets
```

## Clear secrets from repository

Use (bfg)[../bfg-repo-cleaner.md]

Prepare with:

```bash
bfg --replace-text extracted-secrets
```

Clean secrets with:

```bash
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```
