# Clean Git repositories with BFG

With [BFG](https://rtyley.github.io/bfg-repo-cleaner/) large or troublesome files can be removed from a Git Repository

## Files

Delete a file in a Git repository and force push the new commit history.

```bash
bfg --delete-files file.md
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push --force
```

## Secrest

A file with a list of secrets can be used to remove all occurrences in the git repository

`leaked-passwords.txt`

```bash
PASSWORD1                       # Replace literal string 'PASSWORD1' with '***REMOVED***' (default)
PASSWORD2==>examplePass         # replace with 'examplePass' instead
PASSWORD3==>                    # replace with the empty string
regex:password=\w+==>password=  # Replace, using a regex
regex:\r(\n)==>$1               # Replace Windows newlines with Unix newlines
```

```bash
bfg --replace-text leaked-passwords.txt
```

```bash
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```
