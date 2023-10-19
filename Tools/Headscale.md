# Headscale

Headscale is a self-hosted, open source implementation of the Tailscale control server.


## Connect a client to the server

### Create a user

In case you don't have a user yet, you can create one with the following command:

```bash
headscale users create <user>
```

### Get an authkey for the user

```bash
headscale --user <user> preauthkeys create --reusable --expiration 1h
```

### Authenticate tailscale client

```bash
tailscale up --login-server <headscale url> --authkey <authkey>
```

#### Check status

```bash
tailscale status
```
