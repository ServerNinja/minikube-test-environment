#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

HELM_REPO=https://emberstack.github.io/helm-charts
REPO_NAME=emberstack
HELM_CHART=reflector
NAMESPACE=reflector
HELM_RELEASE=reflector

install_helm_chart $HELM_REPO $REPO_NAME $HELM_CHART $NAMESPACE $HELM_RELEASE