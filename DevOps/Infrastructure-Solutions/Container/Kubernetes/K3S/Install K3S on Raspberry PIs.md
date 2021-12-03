
# Manager

```bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
```

Get a token for the worker nodes

```bash
sudo cat /var/lib/rancher/k3s/server/token
```


# Worker Node

Set the K3S Token

```bash
export K3S_TOKEN=blablabla
```


```
curl -sfL https://get.k3s.io | K3S_URL=https://manager01.fritz.box:6443 K3S_TOKEN=$K3S_TOKEN sh -
```

[Generate kubeconfig](https://docs.d2iq.com/dkp/kommander/2.0/clusters/attach-cluster/generate-kubeconfig/)
