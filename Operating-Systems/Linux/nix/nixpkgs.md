# nixpkgs

## Get GitHub checksums

```bash
nix-prefetch-url --unpack https://github.com/catppuccin/bat/archive/f0dedf515c02799b76a2804db9815a479f6c0075.zip
```

```bash
REPO=""
```

```bash
rm -rf /tmp/repo-check
git clone --depth 1 "$REPO" /tmp/repo-check
git -C /tmp/repo-check rev-parse HEAD
rm -rf /tmp/repo-check/.git
nix hash path /tmp/repo-check
```

```yaml
fetchFromGitHub {
  owner = "owner";
  repo = "repo";
  rev = "65bb66d364e0d10d00bd848a3d35e2755654655b";
  hash = "sha256-8EUDsWeTeZwJNrtjEsUNLMt9I9mjabPRBZG83u7xtPw=";
}
```


## Build

```bash
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
```

## Test-Install

```bash
nix-env -iA <package> -f <path to repo>
```

## Submitting Changes

<https://nixos.org/manual/nixpkgs/stable/#chap-submitting-changes>


### Maintainer

Add yourself to the `nixpkgs/maintainers/maintainer-list.nix` file.

Format

```bash
handle = {
  # Required
  name = "Your name";
  email = "address@example.org";
  # Optional
  matrix = "@user:example.org";
  github = "GithubUsername";
  githubId = your-github-id;
  keys = [{
    longkeyid = "rsa2048/0x0123456789ABCDEF";
    fingerprint = "AAAA BBBB CCCC DDDD EEEE  FFFF 0000 1111 2222 3333";
  }];
};
```
