# aardvark-dns problems (request timed out)

My uptime-kuma instance started throwing `ECONNRESET` errors.

So I tried to investigate the issues with a manual dig and got time outs
```bash
dig google.com @192.168.3.20
;; communications error to 192.168.3.20#53: timed out
;; communications error to 192.168.3.20#53: timed out
;; communications error to 192.168.3.20#53: timed out

; <<>> DiG 9.18.24 <<>> google.com @192.168.3.20
;; global options: +cmd
;; no servers could be reached
```

The journal showed errors from the aardvark-dns service

```bash
[root@ap01 ~]# journalctl -f | grep -i dns 
Mar 23 23:44:21 ap01 aardvark-dns[2419]: 9296 dns request got empty response
Mar 23 23:44:26 ap01 aardvark-dns[2419]: 9296 dns request got empty response
Mar 23 23:44:26 ap01 aardvark-dns[2419]: 28012 dns request got empty response
Mar 23 23:44:31 ap01 aardvark-dns[2419]: 28012 dns request got empty response
Mar 23 23:44:44 ap01 aardvark-dns[2419]: 44234 dns request got empty response
```

After restarting the host there were no more errors in the journal.
But some hours forward, they were there again... About 3 error messages per second.

I had two services running which were making a lot of dns requests uptime-kuma and prometheus.
So I stopped the containers for both services and the error messages.

When I started uptime-kuma again, after a few seconds there were some messages in the journal and the application
itself showed problems with dns resolution.

So again restarting and trying to find out when the problems occur.

```bash
podman run --rm -ti --network proxy ubuntu bash
apt update -y && apt install dnsutils -y
for i in {1..10000}; do dig google.com +short; done
```

After about 30 seconds maybe every 20 dig resulted in an error.
And after some minutes the problems showed every fifth dig command.

So I wanted debug logs of aardvark-dns.
The service gets started with the first podman run command and inherits its log level.

```bash
[root@ap01 ~]# ps aux | grep aardvark
podman     18277  0.1  0.1 816992  4540 ?        Ssl  23:32   0:00 /usr/libexec/podman/aardvark-dns --config /tmp/containers-user-2000/containers/networks/aardvark-dns -p 53 run

kill 18277

podman run --rm -ti --debug ubuntu bash
apt update -y && apt install dnsutils

dig google.com +short
```

Now we can see more details in the journal

```bash
Mar 24 23:34:50 ap01 aardvark-dns[18277]: parsed message "[54900] parsed message body: google.com. A IN edns: true"
Mar 24 23:34:50 ap01 aardvark-dns[18277]: request source address: 10.89.0.19:46989
Mar 24 23:34:50 ap01 aardvark-dns[18277]: checking if backend has entry for: "google.com."
Mar 24 23:34:50 ap01 aardvark-dns[18277]: No backend lookup found, try resolving in current resolvers entry
Mar 24 23:34:50 ap01 aardvark-dns[18277]: Not found, forwarding dns request for "google.com."
Mar 24 23:34:50 ap01 aardvark-dns[18277]: 54900 google.com. A IN => Some(
Mar 24 23:34:50 ap01 aardvark-dns[18277]: [54900] success reponse
Mar 24 23:34:50 ap01 aardvark-dns[18277]: parsed message "[5383] parsed message body: google.com. A IN edns: true"
Mar 24 23:34:50 ap01 aardvark-dns[18277]: request source address: 10.89.0.19:32889
Mar 24 23:34:50 ap01 aardvark-dns[18277]: checking if backend has entry for: "google.com."
Mar 24 23:34:50 ap01 aardvark-dns[18277]: No backend lookup found, try resolving in current resolvers entry
Mar 24 23:34:50 ap01 aardvark-dns[18277]: Not found, forwarding dns request for "google.com."
Mar 24 23:34:50 ap01 aardvark-dns[18277]: 48955 dns request got empty response
```

Running a tcpdump shows only correct responses

```bash
tcpdump -nnl host 1.1.1.1 and port 53
```


I have installed podman with the [copr podman-next repo](https://copr.fedorainfracloud.org/coprs/rhcontainerbot/podman-next/).

Podman wasn't updated on the host long time before the issue happened, but I still wanted to try if the stable
podman version shows the same problem.


So lets first export the podman volumes to be on the safe side

`export-volumes.sh`

```bash
#!/bin/bash

EXPORT_DIR="./volumes/"
VOLUME_LIST=$(podman volume ls -q)

for volume in $VOLUME_LIST; do
    echo "Exporting volume $volume"
    podman volume export $volume -o "$EXPORT_DIR/$volume.tar"
done

echo "All volumes exported to $EXPORT_DIR"
```

After that I disabled the copr repo

```bash
[root@ap01 ~]# dnf copr disable copr.fedorainfracloud.org/rhcontainerbot/podman-next
[root@ap01 ~]# dnf copr list
copr.fedorainfracloud.org/rhcontainerbot/podman-next

[root@ap01 ~]# dnf clean all
```

Reinstalled podman and rebooted the system

```bash
dnf remove podman -y && dnf makecache && dnf install podman -y
shutdown -r now
```

After the reboot everything worked like it used to.

And its there again after about 24 hours.

So we open two panels one as root where we tcpdump and in a podman container

```bash
root@3c6773429be7:/# for i in {1..300}; do dig google.com @pihole.wrage.eu +short && sleep 1; done 
; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> google.com @pihole.wrage.eu +short
;; global options: +cmd
;; no servers could be reached

^C^C;; communications error to 192.168.3.20#53: timed out
;; communications error to 192.168.3.20#53: timed out
;; communications error to 192.168.3.20#53: timed out

; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> google.com @pihole.wrage.eu +short
;; global options: +cmd
;; no servers could be reached

^C;; communications error to 192.168.3.20#53: timed out
;; communications error to 192.168.3.20#53: timed out
;; communications error to 192.168.3.20#53: timed out
```

```bash
23:14:39.375115 ens18 Out IP ap01.60520 > pi.hole.domain: 33823+ [1au] A? google.com. (51)
23:14:39.375379 ens18 In  IP pi.hole.domain > ap01.60520: 33823 1/0/1 A 172.217.16.78 (55)
23:14:44.377509 ens18 Out IP ap01.40087 > pi.hole.domain: 33823+ [1au] A? google.com. (51)
23:14:44.377824 ens18 In  IP pi.hole.domain > ap01.40087: 33823 1/0/1 A 172.217.16.78 (55)
23:14:49.382853 ens18 Out IP ap01.44508 > pi.hole.domain: 33823+ [1au] A? google.com. (51)
23:14:49.383149 ens18 In  IP pi.hole.domain > ap01.44508: 33823 1/0/1 A 172.217.16.78 (55)
```

There are clearly answers coming in, but it seems like they are not forwarded to the container

```bash
[podman@ap01 ~]$ podman unshare --rootless-netns nslookup google.com
Server:         169.254.0.1
Address:        169.254.0.1#53

Non-authoritative answer:
Name:   google.com
Address: 172.217.16.78
Name:   google.com
Address: 2a00:1450:4005:800::200e

[podman@ap01 ~]$ podman unshare --rootless-netns nslookup google.com @192.168.3.20
nslookup: couldn't get address for '@192.168.3.20': not found
[podman@ap01 ~]$ podman unshare --rootless-netns nslookup @192.168.3.20 google.com
^C
[podman@ap01 ~]$ podman unshare --rootless-netns nslookup @192.168.3.20 google.com
;; connection timed out; no servers could be reached
```

```bash
[root@ap01 ~]# ps aux | grep slirp4netns
root       15108  0.0  0.0   3880  2152 pts/0    S+   23:28   0:00 grep --color=auto slirp4netns

[podman@ap01 ~]$ ps aux | grep -i pasta
podman      2177  1.3  0.5  76264 37864 ?        Ss   23:30   0:01 /usr/bin/pasta --config-net --pid /tmp/containers-user-2000/containers/networks/rootless-netns/rootless-netns-conn.pid --dns-forward 169.254.0.1 -t none -u none -T none -U none --no-map-gw --quiet --netns /tmp/containers-user-2000/containers/networks/rootless-netns/rootless-netns
```

@tomorrow try to install podman 4.6.1 with slirp4netns
<https://github.com/containers/podman/issues/18530>
