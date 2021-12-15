# Install Argo CD

[Getting Started Guide](https://argo-cd.readthedocs.io/en/stable/getting_started/)

```bash
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

[Download Argo CD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

Create a load balancer to use the API Server

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Get the initial admin secrets
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```



