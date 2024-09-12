#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

HELM_REPO=oci://ghcr.io/bank-vaults/helm-charts
REPO_NAME=bank-vaults
HELM_CHART=vault-operator
NAMESPACE=vault
HELM_RELEASE=vault-operator

install_helm_chart $HELM_REPO $REPO_NAME $HELM_CHART $NAMESPACE $HELM_RELEASE

log_info "Installing vault roles..."
OUTPUT="$(kubectl apply -f $BASEDIR/vault-roles.yaml)"
echo "$OUTPUT" | grep -v "unchanged"

if kubectl get vault vault -n $NAMESPACE >/dev/null 2>&1; then
    log_info "Vault custom resource 'vault' already exists in namespace $NAMESPACE"
else
    log_info "Installing vault custom resource to build vault cluster..."
    kubectl apply -f $BASEDIR/cr-raft.yaml
fi

VAULT_WEBHOOK_RELEASE=vault-secrets-webhook
VAULT_WEBHOOK_HELM_CHART=vault-secrets-webhook
VAULT_WEBHOOK_NAMESPACE=vault-infra

if kubectl get namespace vault-infra >/dev/null 2>&1; then
    log_info "Namespace 'vault-infra' already exists"
else
    log_info "Creating namespace $VAULT_WEBHOOK_NAMESPACE"
    kubectl create namespace $VAULT_WEBHOOK_NAMESPACE 
    kubectl label namespace $VAULT_WEBHOOK_NAMESPACE name=vault-infra
fi

install_helm_chart $HELM_REPO $REPO_NAME $VAULT_WEBHOOK_HELM_CHART $VAULT_WEBHOOK_NAMESPACE $VAULT_WEBHOOK_HELM_RELEASE