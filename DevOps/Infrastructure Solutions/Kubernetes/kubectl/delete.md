# delete pods
```
kubectl get pods -n default | grep Error | cut -d' ' -f 1 | xargs kubectl delete pod
```