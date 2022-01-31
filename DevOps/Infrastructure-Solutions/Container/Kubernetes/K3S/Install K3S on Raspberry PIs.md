
# Manager

## With Traefik
```bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
```

## Without Traefik
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -s - --write-kubeconfig-mode 644
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
apiVersion: rbac.authorization.k8s.io/v1
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

kubectl describe secret home-computer-token

export K8S_SERVER="https://192.168.2.31:6443"
export K8S_CLUSTER="k3s-home"
export K8S_USER="home-computer"
export K8S_USER_TOKEN="blabla" 

kubectl config set-cluster $K8S_CLUSTER --server=$K8S_SERVER --insecure-skip-tls-verify=true
kubectl config set-credentials $K8S_USER --token=$K8S_USER_TOKEN
kubectl config set-context $K8S_CLUSTER --cluster=$K8S_CLUSTER --user=$K8S_USER
kubectl config use-context $K8S_CLUSTER
```
