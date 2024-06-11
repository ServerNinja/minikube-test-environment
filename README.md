# Minikube Testing Environment

## Getting started

Start script that builds the minikube environment
```
./start-minikube.sh -h
Usage: ./start-minikube.sh [OPTIONS]
Options:
  -m <value>   Enable/disable monitoring components (true/false)
  -d <value>   Enable/disable MySQL installation (true/false)
  -h           Show this help message
```

Destroying the minikube environment
```
./destroy-minikube.sh
```

## Accessing Grafana

NOTE: Only works when using the -m switch with `start-minikube.sh`

```
kubectl port-forward svc/grafana-service -n monitoring 3000:3000
```

Grafana Credentials:
- username: admin
- password: password
