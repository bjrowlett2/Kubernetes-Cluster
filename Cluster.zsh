#!/bin/zsh -e

k3d cluster create --config ./Cluster.yaml

# Traefik is bundled with K3s, but we need to wait until
# it is installed and ready before we can apply Ingress Routes.

kubectl wait --for=condition=complete \
    job/helm-install-traefik --timeout=10m -n kube-system
kubectl rollout status deployment/traefik -n kube-system
kubectl apply -f ./Traefik/Ingress-Route.yaml -n kube-system

kubectl create namespace argo-system
helm install -f ./Argo/Values.yaml argo argo/argo-cd -n argo-system
kubectl rollout status deployment/argo-argocd-server -n argo-system
kubectl apply -f ./Argo/Ingress-Route.yaml -n argo-system

kubectl create namespace grafana-system
helm install grafana grafana/grafana -n grafana-system
kubectl rollout status deployment/grafana -n grafana-system
kubectl apply -f ./Grafana/Ingress-Route.yaml -n grafana-system

kubectl create namespace prometheus-system
helm install prometheus prometheus/prometheus -n prometheus-system
kubectl rollout status deployment/prometheus-server -n prometheus-system
kubectl apply -f ./Prometheus/Ingress-Route.yaml -n prometheus-system
