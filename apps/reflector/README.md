
```
# Add repo
helm repo add emberstack https://emberstack.github.io/helm-charts
helm repo update

# Install via helm
helm upgrade --install reflector -n reflector --create-namespace emberstack/reflector
```

# To annotate secrets to all namespaces
```
kubectl annotate secret <secret_name> reflector.v1.k8s.emberstack.com/reflection-allowed="true" --overwrite=true
kubectl annotate secret <secret_name> reflector.v1.k8s.emberstack.com/reflection-auto-enabled="true" --overwrite=true
```