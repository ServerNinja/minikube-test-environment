#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

HELM_REPO=oci://registry-1.docker.io/bitnamicharts
HELM_CHART=mysql
NAMESPACE=mysql
HELM_RELEASE=mysql
HELM_VALUES="$BASEDIR/values.yaml"

install_helm_chart $HELM_REPO $REPO_NAME $HELM_CHART $NAMESPACE $HELM_RELEASE $HELM_VALUES

log_info "Annotate the mysql secret for reflection..."
kubectl annotate secret mysql -n mysql reflector.v1.k8s.emberstack.com/reflection-allowed="true" --overwrite=true
kubectl annotate secret mysql -n mysql reflector.v1.k8s.emberstack.com/reflection-auto-enabled="true" --overwrite=true