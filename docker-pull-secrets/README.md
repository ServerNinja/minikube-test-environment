# Pull secrets for ghcr.io

```
GITHUB_USER=serverninja@gmail.com
echo -n "Enter your password / Private token: "
read -s GITHUB_PASS

kubectl create secret docker-registry ghcr-login-secret \
  --docker-server=https://ghcr.io \
  --docker-username=$GITHUB_USER \
  --docker-password=$GITHUB_PASS

kubectl annotate secret ghcr-login-secret reflector.v1.k8s.emberstack.com/reflection-allowed="true" --overwrite=true
kubectl annotate secret ghcr-login-secret reflector.v1.k8s.emberstack.com/reflection-auto-enabled="true" --overwrite=true
```