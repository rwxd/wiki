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
bandit8@bandit:~$ sort data.txt | uniq -c | grep "1\s"
      1 UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR
```

## Level 9 -> 10

```bash
bandit9@bandit:~$ strings data.txt | grep -E "=+"
========== the*2i"4
=:G e
========== password
<I=zsGi
Z)========== is
A=|t&E
Zdb=
c^ LAh=3G
*SF=s
&========== truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk
S=A.H&^
```

## Level 10 -> 11

```bash
bandit10@bandit:~$ cat data.txt | base64 -d | sed "s/The\spassword\sis\s\(.*\)/\1/g"
IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR
```

## Level 11 -> 12

```bash
bandit11@bandit:~$ cat data.txt | tr "a-zA-Z" "n-za-mN-ZA-M"
The password is 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu
```

## Level 12 -> 13

```bash
bandit12@bandit:~$ mkdir -p /tmp/abcdef && cd !$
bandit12@bandit:/tmp/abcdef$ xxd -r ~/data.txt data.txt

bandit12@bandit:/tmp/abcdef$ file data.txt
data.txt: gzip compressed data, was "data2.bin", last modified: Thu May  7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/abcdef$ mv data.txt data.gz
bandit12@bandit:/tmp/abcdef$ gzip -d data.gz

bandit12@bandit:/tmp/abcdef$ file data
data: bzip2 compressed data, block size = 900k
bandit12@bandit:/tmp/abcdef$ mv data data.bz2
bandit12@bandit:/tmp/abcdef$ bzip2 -d data.bz2

bandit12@bandit:/tmp/abcdef$ file data
data: gzip compressed data, was "data4.bin", last modified: Thu May  7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/abcdef$ mv data data.gz

bandit12@bandit:/tmp/abcdef$ gzip -d data.gz
bandit12@bandit:/tmp/abcdef$ file data
data: POSIX tar archive (GNU)

bandit12@bandit:/tmp/abcdef$ mv data data.tar
bandit12@bandit:/tmp/abcdef$ tar xvf data.tar
data5.bin

bandit12@bandit:/tmp/abcdef$ file data5.bin
data5.bin: POSIX tar archive (GNU)
bandit12@bandit:/tmp/abcdef$ tar xvf data6.bin
data8.bin

bandit12@bandit:/tmp/abcdef$ file data8.bin
data8.bin: gzip compressed data, was "data9.bin", last modified: Thu May  7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/abcdef$ mv data8.bin data8.gz
bandit12@bandit:/tmp/abcdef$ gzip -d data8.gz

bandit12@bandit:/tmp/abcdef$ file data8
data8: ASCII text
bandit12@bandit:/tmp/abcdef$ cat data8
The password is 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL
```

## Level 13 -> 14

```bash
bandit13@bandit:~$ eval $(ssh-agent)
Agent pid 20358
bandit13@bandit:~$ ssh-add sshkey.private
Identity added: sshkey.private (sshkey.private)
bandit13@bandit:~$ ssh bandit14@localhost
```

## Level 14 -> 15

```bash
bandit14@bandit:~$ cat /etc/bandit_pass/bandit14 | netcat localhost 30000
Correct!
BfMYroe26WYalil77FoDi9qh59eK5xNr
```

## Level 15 -> 16

```bash

```