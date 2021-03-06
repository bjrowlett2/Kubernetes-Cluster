@ECHO OFF

k3d.exe cluster create --config .\Cluster.yaml

REM Traefik is bundled with K3s, but we need to wait until
REM it is installed and ready before we can apply Ingress Routes.

kubectl.exe wait --for=condition=complete ^
    job/helm-install-traefik --timeout=10m -n kube-system
kubectl.exe rollout status deployment/traefik -n kube-system
kubectl.exe apply -f .\Traefik\Ingress-Route.yaml -n kube-system

kubectl.exe create namespace argo-system
helm.exe install -f .\Argo\Values.yaml argo argo/argo-cd -n argo-system
kubectl.exe rollout status deployment/argo-argocd-server -n argo-system
kubectl.exe apply -f .\Argo\Ingress-Route.yaml -n argo-system

kubectl.exe create namespace grafana-system
helm.exe install grafana grafana/grafana -n grafana-system
kubectl.exe rollout status deployment/grafana -n grafana-system
kubectl.exe apply -f .\Grafana\Ingress-Route.yaml -n grafana-system

kubectl.exe create namespace prometheus-system
helm.exe install prometheus prometheus/prometheus -n prometheus-system
kubectl.exe rollout status deployment/prometheus-server -n prometheus-system
kubectl.exe apply -f .\Prometheus\Ingress-Route.yaml -n prometheus-system
