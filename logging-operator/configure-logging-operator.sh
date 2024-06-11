#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

HELM_REPO="oci://ghcr.io/kube-logging/helm-charts"
HELM_CHART=logging-operator
NAMESPACE=logging-operator
HELM_RELEASE=logging-operator

install_helm_chart $HELM_REPO $REPO_NAME $HELM_CHART $NAMESPACE $HELM_RELEASE

log_info "Configure logging-operator custom resources..."
OUTPUT="$(kubectl apply -f $BASEDIR/logging.yaml)"
echo "$OUTPUT" | grep -v "unchanged"