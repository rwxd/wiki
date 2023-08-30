# Login with the ArgoCD Cli in the current cluster

## Prerequisites

- ArgoCD is installed in the current cluster
- ArgoCD Cli is installed on your machine

## Steps

```bash
# change the default namespace of your current context to argocd
kubectl config set-context --current --namespace=argocd

argocd login --core
```

Check for access to the API Server

```bash
argocd app list
```
