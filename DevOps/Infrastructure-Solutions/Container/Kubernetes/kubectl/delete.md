# delete all pods from a namespace or a different query
```
kubectl get pods -n default | grep Error | cut -d' ' -f 1 | xargs kubectl delete pod
```