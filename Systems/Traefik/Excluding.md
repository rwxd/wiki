```
services:
  whoami:
    image: "traefik/whoami"
    container_name: "whoami-test"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami-test.rule=Host(`whoami-test.fritz.box`)"
      - "traefik.http.routers.whoami-test.entrypoints=http"
      - "traefik.http.routers.whoami-test.middlewares=intern_whitelist"
      - "traefik.http.middlewares.intern_whitelist.ipwhitelist.sourcerange=192.168.2.0/23"
      - "traefik.http.middlewares.intern_whitelist.ipwhitelist.ipstrategy.excludedips=192.168.2.1, 192.168.2.124"
```