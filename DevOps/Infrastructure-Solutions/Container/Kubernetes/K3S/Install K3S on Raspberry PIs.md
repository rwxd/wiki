
# Manager
```bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
```

Get the worker node command from the output.

# Worker 

```
curl -sfL https://get.k3s.io | K3S_URL=https://manager01.fritz.box:6443 K3S_TOKEN="" sh -
```