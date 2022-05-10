# MetalLB

## Install with kubectl

https://metallb.universe.tf/installation/

```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml
```

## config
```
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.3.200-192.168.3.250
```

## Install with Terraform

```terraform
resource "kubernetes_namespace" "metallb" {
  metadata {
    name = "metallb"
  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  namespace  = "metallb"

  depends_on = [kubernetes_namespace.metallb]

  set {
    name  = "configInline.address-pools[0].name"
    value = "default"
    type  = "string"
  }

  set {
    name  = "configInline.address-pools[0].protocol"
    value = "layer2"
    type  = "string"
  }

  set {
    name  = "configInline.address-pools[0].addresses[0]"
    value = "192.168.3.200-192.168.3.250"
    type  = "string"
  }
}
```

