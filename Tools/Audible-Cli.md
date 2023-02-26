# Audible CLI

<https://github.com/mkb79/audible-cli>

## Setup

### Authfile

```bash
audible manage auth-file add --password "<password>"
```

### Profile

```bash
audible manage profile add
```

## Download all audio books to the current directory

```bash
audible -P default -v info download --all --aax --ignore-podcasts --jobs 3 --ignore-errors
```

## Convert aax to mp3

<https://github.com/KrumpetPirate/AAXtoMP3>

### Get the auth token from audible-cli

```bash
audible -P default activation-bytes
```

### Convert aax to mp3

```bash
aaxtomp3 -e:mp3 --level 5 -s --authcode <authcode> --loglevel 1 <file.aax>
```

### Convert all aax to mp3


```bash
find . -name "*.aax" -exec aaxtomp3 -e:mp3 --level 5 -s --authcode <authcode> --loglevel 1 --complete_dir <path> {} \;
```
