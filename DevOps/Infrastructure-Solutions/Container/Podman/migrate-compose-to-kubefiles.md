# Migrate from podman-compose to Kubefiles

## Overview

Kubefiles are a way to define a podman pod and containers in a single file. They are similar to docker-compose files,
but can also be used with Kubernetes.

## Requirements

The podman-compose or docker-compose file must be started with `podman-compose up -d` and the created podman pod should be listed with `podman pod ls`.

## Generate Kubefiles

### Pod

Get the pod name via `podman pod ls` and generate the Kubefile with:

```bash
podman kube generate <pod_name> -f pod.kube.yaml
```

### Persistent Volume Claim

Get the volume name via `podman volume ls` and generate the Kubefile with:

```bash
podman kube generate <volume_name> -f pvc.kube.yaml
```
