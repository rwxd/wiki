
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

# Create a Service Account for kubectl
```bash
kubectl -n default apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: home-computer
EOF

kubectl -n default apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: gitlab-service-account-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: home-computer
    namespace: default
EOF
```
