```
http:
  routers:
    intern: {}
      entryPoints:
        - "http"
        - "https"
      rule: "Host(`HostRegexp(`fritz.box`, `{subdomain:[a-z]+}.fritz.box`, ...)`)"
    pihole:
      entryPoints:
        - "http"
        - "https"
      rule: "Host(`pihole.fritz.box`)"
      service: pihole
      middlewares:
        - addprefix-pihole
  services:
    pihole:
      loadBalancer:
        servers:
          - url: "http://192.168.2.19:80"
        passHostHeader: true
  middlewares:
    addprefix-pihole:
      addPrefix:
        prefix: "/admin"
```