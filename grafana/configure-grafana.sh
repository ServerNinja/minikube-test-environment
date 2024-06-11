#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

HELM_REPO="oci://ghcr.io/grafana/helm-charts"
HELM_CHART=grafana-operator
NAMESPACE=monitoring
HELM_RELEASE=grafana-operator
HELM_CHART_VERSION=v5.9.2

install_helm_chart $HELM_REPO $REPO_NAME $HELM_CHART $NAMESPACE $HELM_RELEASE $HELM_CHART_VERSION

log_info "Configure grafana custom resources..."
OUTPUT="$(kubectl apply -f $BASEDIR/grafana.yaml)"
echo "$OUTPUT" | grep -v "unchanged"