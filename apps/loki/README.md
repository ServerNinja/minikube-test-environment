# Grafana Loki

Add helm repo
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

Install Loki
```
helm upgrade --install -n loki --create-namespace --values loki-values.yaml loki grafana/loki
```