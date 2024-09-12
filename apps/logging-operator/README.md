# Logging-operator

Install logging operator
```
helm upgrade --install --wait --create-namespace --namespace logging-operator logging-operator oci://ghcr.io/kube-logging/helm-charts/logging-operator
```

Install Logging Components:
```
kubectl apply -f logging.yaml
```