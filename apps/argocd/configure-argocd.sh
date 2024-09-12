#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

HELM_REPO="https://argoproj.github.io/argo-helm"
REPO_NAME=argocd
HELM_CHART=argo-cd
NAMESPACE=argocd
HELM_RELEASE=argocd
HELM_CHART_VERSION=v7.5.2
HELM_VALUES="$BASEDIR/argocd-values.yaml"

install_helm_chart $HELM_REPO $REPO_NAME $HELM_CHART $NAMESPACE $HELM_RELEASE $HELM_CHART_VERSION $HELM_VALUES
