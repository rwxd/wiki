# Bandit

[Bandit](https://overthewire.org/wargames/bandit/)

## Level 0

just login `ssh bandit0@bandit.labs.overthewire.org -p 2220` and password `bandit0`

## Level 0 -> 1

Password for level 2 is in the `~/readme` file.

```bash
bandit0@bandit:~$ cat readme
boJ9jbbUNNfktd78OOpsqOltutMc3MY1
```

## Level 1 -> 2

```bash
bandit1@bandit:~$ cat "./-"
CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9
```

## Level 2 -> 3

```bash
bandit2@bandit:~$ cat ./spaces\ in\ this\ filename
UmHadQclWmgdLOKQ3YNgjWxGoRMb5luK
```

## Level 3 -> 4

```bash
bandit3@bandit:~$ cat inhere/.hidden
pIwrPrtPN36QITSp3EQaw936yaFoFgAB
```

## Level 4 -> 5

```bash
bandit4@bandit:~$ find inhere/ -type f | xargs file | grep tex
inhere/-file07: ASCII text
bandit4@bandit:~$ cat inhere/-file07
koReBOKuIDDepwhWk7jZC0RTdopnAYKh
```

## Level 5 -> 6

```bash
bandit5@bandit:~$ find inhere/ -type f -size 1033c ! -executable | xargs file | grep text 
inhere/maybehere07/.file2: ASCII text, with very long lines
bandit5@bandit:~$ cat inhere/maybehere07/.file2
DXjZPULLxYr17uwoI01bNLQbtFemEgo7
```

## Level 6 -> 7

```bash
bandit6@bandit:~$ find / -user bandit7 -group bandit6 -size 33c 2>/dev/null | xargs cat
HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs
```

## Level 7 -> 8

```bash
bandit7@bandit:~$ cat data.txt | grep "millionth" | sed "s/millionth\s*//g"
cvX2JJa4CFALtqS87jk27qwqGhBM9plV
```

## Level 8 -> 9

```bash

```