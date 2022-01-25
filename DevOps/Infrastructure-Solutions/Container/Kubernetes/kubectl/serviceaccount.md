# ServiceAccounts
## Create a ServiceAccount
gitlab-service-account.yml with ClusterRoleBinding
```yml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab-service-account

---
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
    name: gitlab-service-account
    namespace: default
```

gitlab-service-account.yml with RoleBinding
```yml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab-service-account
  namespace: <KUBE_NAMESPACE>

---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: cicd-role
  namespace: <KUBE_NAMESPACE>
rules:
- apiGroups:
  - ""
  - apps
  - extensions
  resources:
  - '*'
  verbs:
  - '*'

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: cicd-role
  namespace: <KUBE_NAMESPACE>
subjects:
  - kind: ServiceAccount
    name: gitlab-service-account
roleRef:
  kind: Role
  name: cicd-role
  apiGroup: rbac.authorization.k8s.io
```

### Get the created token
```bash
kubectl -n <KUBE_NAMESPACE> describe secret gitlab-service-account-token-
```

```bash
export K8S_SERVER="https://10.24.1.1:6443"
export K8S_CLUSTER="gitlab-test"
export K8S_USER="gitlab-service-account"
export K8S_USER_TOKEN="" 

kubectl config set-cluster $K8S_CLUSTER --server=$K8S_SERVER --insecure-skip-tls-verify=true
kubectl config set-credentials $K8S_USER --token=$K8S_USER_TOKEN
kubectl config set-context $K8S_CLUSTER --cluster=$K8S_CLUSTER --user=$K8S_USER
kubectl config use-context $K8S_CLUSTER
```