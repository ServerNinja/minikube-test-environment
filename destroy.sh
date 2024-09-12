#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/.lib/common.sh"

export PROVIDER="$(jq -r '.provider' "$BASEDIR/config.json")"


if [ "$PROVIDER" = "kind" ]; then
  # Checking for required command line utilities
  check_required_utils kind kubectl helm jq

  log_warning "Destroying kind cluster instance..."

  kind delete cluster
elif [ "$PROVIDER" = "minikube" ]; then
  # Checking for required command line utilities
  check_required_utils minikube kubectl helm jq

  log_warning "Destroying minikube instance..."

  minikube delete
fi
