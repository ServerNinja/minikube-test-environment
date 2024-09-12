# Prometheus

Add the prometheus community helm repo
```
helm repo add prometheus https://prometheus-community.github.io/helm-charts
helm repo update
```

Install prometheus
```
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```