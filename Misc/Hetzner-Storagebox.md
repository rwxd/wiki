# Hetzner Storagebox

## Copy SSH Key for User

```bash
cat ~/.ssh/id_ed25519.pub | ssh -p23 uXXXX-sub1@uXXXX.your-storagebox.de install-ssh-key
```

## Borg

### Borgmatic

#### Init

```bash
borgmatic -c /etc/borgmatic.d/hetzner.yaml init --encryption repokey
borgmatic -c /etc/borgmatic.d/hetzner.yaml borg key export
```

#### Upgrade

```bash
borgmatic -c /etc/borgmatic.d/hetzner.yaml borg info --debug 2>&1 | grep TAM | grep -i manifest
borgmatic -c /etc/borgmatic.d/hetzner.yaml borg list --consider-checkpoints --format='{name} {time} tam:{tam}{NL}'
BORG_WORKAROUNDS=ignore_invalid_archive_tam borgmatic -c /etc/borgmatic.d/hetzner.yaml borg list --consider-checkpoints --format='{name} {time} tam:{tam}{NL}'
BORG_WORKAROUNDS=ignore_invalid_archive_tam borgmatic borg upgrade --archives-tam
```
