#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

HELM_REPO=https://grafana.github.io/helm-charts
REPO_NAME=grafana
HELM_CHART=loki
NAMESPACE=loki
HELM_RELEASE=loki
HELM_VALUES="$BASEDIR/loki-values.yaml"

install_helm_chart $HELM_REPO $REPO_NAME $HELM_CHART $NAMESPACE $HELM_RELEASE $HELM_VALUES
