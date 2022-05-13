# Git Crypt

## How to

## Init

Initialize repository with `git-crypt init`

## Files to encrypt

Create a `.gitattributes` file

```bash
touch .gitattributes
```

The `.gitattatributes` file contains line with the following form:

```bash
[file pattern] attr1=value1 attr2=value2
```

### Example

If we want to encrypt the file `config.yml`, the `.gitattatributes` should contain the following:

```bash
config.yml filter=git-crypt diff=git-crypt
```

With `git-crypt status` we can see that our file will be encrypted on push to our remote repository.

```bash
❯ git-crypt status | grep "config.yml"
    encrypted: config.yml
```

## Locking

With `git-crypt lock` and `git-crypt unlock` the repository can be unlocked at will.

## Adding additional users with gpg keys

`git-crypt add-gpg-user KEYID`
