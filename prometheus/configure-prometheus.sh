#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

HELM_REPO=https://prometheus-community.github.io/helm-charts
REPO_NAME=prometheus
HELM_CHART=kube-prometheus-stack
NAMESPACE=monitoring
HELM_RELEASE=prometheus

install_helm_chart $HELM_REPO $REPO_NAME $HELM_CHART $NAMESPACE $HELM_RELEASE