# Grafana Operator / Grafana

```
helm upgrade -i -n monitoring --create-namespace grafana-operator oci://ghcr.io/grafana/helm-charts/grafana-operator --version v5.9.2
```

# Install Grafana and datasources:
```
kubectl apply -f grafana.yaml
```

# Accessing Grafana Interface
```
kubectl port-forward svc/grafana-service -n monitoring 3000:3000
```

username: admin
password: password