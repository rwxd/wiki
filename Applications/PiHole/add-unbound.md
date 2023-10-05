# Add Unbound as a recursive DNS Server to the PiHole setup

## Why would you want this?

- Using a recursive DNS server is more secure, because no third party DNS server will be used
and you will not be tracked by your DNS provider
- The request time will be faster because the DNS server is running locally
- Unbound will use DNSSEC to verify DNS requests

## Install

```bash
sudo apt install unbound
```

## Configuration

Configure unbound with:

- Listen on port 5335
- TCP & UDP
- DNSSEC
- Enable IPv4 & IPv6
- Ensure privacy of local IP ranges

```yaml
cat << EOF > /etc/unbound/unbound.conf.d/pi-hole.conf
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    # view more statistics
    extended-statistics: yes

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: yes

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    # Needs to be commented out if you have a public dns records (e.g. Cloudflare) resolving to
    # your local IP. Those records will otherwise be unresolvable.
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
EOF
```

Signal PiHole to use this limit

```python
cat << EOF > /etc/dnsmasq.d/99-edns.conf
edns-packet-max=1232
EOF
```

### Restart unbound

```bash
sudo systemctl restart unbound
```

### Test unbound

#### Query

```bash
dig google.com @127.0.0.1 -p 5335
```

#### DNSSec

Get `Servfail`

```bash
dig sigfail.verteiltesysteme.net @127.0.0.1 -p 5335
```

Get `NOERROR`

```bash
dig sigok.verteiltesysteme.net @127.0.0.1 -p 5335
```

### Configure PiHole

Now we need to tell PiHole to use unbound as an upstream DNS server.

This is done by editing `/etc/pihole/setupVars.conf` and adding/replacing the following line:

```bash
PIHOLE_DNS_1=127.0.0.1#5335
PIHOLE_DNS_2=127.0.0.1#5335
```

Restart PiHole

```bash
systemctl restart pihole-FTL.service
```

The PiHole web interface should now show under `/admin/settings.php?tab=dns` that the upstream DNS server is `127.0.0.1#5335`.

Under `/admin/queries.php` you should see that the queries are now forwarded to `127.0.0.1#5335`.

If that is not the case, maybe you need to manually save the settings in the web interface under `/admin/settings.php?tab=dns`.
