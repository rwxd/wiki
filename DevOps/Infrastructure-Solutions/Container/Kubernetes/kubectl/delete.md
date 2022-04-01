# delete all pods from a namespace that are in Error Status
```
NAMESPACE=test && kubectl get pods -n $NAMESPACE | grep Error | cut -d' ' -f 1 | xargs kubectl delete pod -n $NAMESPACE
```
