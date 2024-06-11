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

## Configuration Options
The `config.json` file allows you to configure various options for the Minikube testing environment. Here are the available options:

- `cpus`: Type: integer - Defines the number of CPU cores dedicated to minikube
- `memory`: Type: integer - Defines the amount of RAM to dedicate to minikube
- `driver`:  Type: string - Defines the driver to use for minikube (Currently only tested "qemu2" and "virtualbox")
- `network`: Type: string - Defines the network config to use. For "qemu", we tested "builtin" and socket_vmnet. For "virtualbox", we recommend "builtin"

You can modify the values in the `config.json` file to customize the behavior of the Minikube environment according to your needs.