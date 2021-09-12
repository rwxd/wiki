# Clean Git repositories with BFG

With [BFG](https://rtyley.github.io/bfg-repo-cleaner/) large or troublesome files can be removed from a Git Repository

Delete a file in a Git repository and force push changes.

```bash
bfg --delete-files file.md
git add .
git push --force
```
