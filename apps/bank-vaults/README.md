# Bank-Vaults

## Install Vault Operator and Vault:

Install the operator
```
helm upgrade --install --namespace vault --create-namespace --wait vault-operator oci://ghcr.io/bank-vaults/helm-charts/vault-operator --values vault-operator-values.yaml
```

Configure roles and clusterRoles for vault cluster
```
kubectl apply -f vault-roles.yaml
```

Configure vault cluster
```
kubectl apply -f cr-raft.yaml
```

## Install vault-secrets-webhook

Create namespace
```
kubectl create namespace vault-infra
kubectl label namespace vault-infra name=vault-infra
```

Install the helm chart
```
helm upgrade --install --wait vault-secrets-webhook oci://ghcr.io/bank-vaults/helm-charts/vault-secrets-webhook --namespace vault-infra
```

