# Kubernetes Cluster

Spin up a local Kubernetes cluster in seconds.

## Required Software

* [k3d.exe](https://github.com/k3d-io/k3d/releases) - a lightweight wrapper to run k3s.
* [helm.exe](https://github.com/helm/helm/releases) - the package manager for Kubernetes.

## Required Helm Repositories

```
> helm.exe repo add argo https://argoproj.github.io/argo-helm
> helm.exe repo add prometheus https://prometheus-community.github.io/helm-charts
> helm.exe repo update
```
