# Minikube Testing Environment

## Getting started

**NOTE**: See `config.json` to configure options

Start script that builds the minikube environment
```
./start-minikube.sh -h
Usage: ./start-minikube.sh [OPTIONS]
Options:
  -m    Enable monitoring components
  -d    Enable MySQL installation
  -h    Show this help message
```

Destroying the minikube environment
```
./destroy-minikube.sh
```

## Accessing Grafana

**NOTE**: Only works when using the -m switch with `start-minikube.sh`

```
kubectl port-forward svc/grafana-service -n monitoring 3000:3000
```

Grafana Credentials:
- username: admin
- password: password
