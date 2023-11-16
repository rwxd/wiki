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

### File permissions

Get the current ids with `stat <file>` or `stat <directory>`.

Give the permission to the podman user with `chown <podman_user>:<podman_group> <file>` or `chown -R <podman_user>:<podman_group> <directory>`.

Use podman to change the permission to the uid and gid found with `stat`.

```bash
podman unshare chown <uid>:<gid> <file>

# or

podman unshare chown -R <uid>:<gid> <directory>
```

### Persistent Volume Claim

Get the volume name via `podman volume ls` and generate the Kubefile with:

```bash
podman kube generate <volume_name> -f pvc.kube.yaml
```
