#!/usr/bin/env bash
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Import common functions
. "$BASEDIR/.lib/common.sh"

export PROVIDER="$(jq -r '.provider' "$BASEDIR/config.json")"

start_kind() {
    CMD="kind create cluster"
    log_warning "Starting kind with the following command:"
    log_warning -e "$CMD"

    $CMD
}

is_kind_running() {
    kind get clusters 2> /dev/null | grep kind
    if [ $? -eq 0 ]; then
        log_info "Kind cluster is already running"
        return 0
    else
        log_warning "Kind cluster is not running"
        return 1
    fi
}

start_minikube() {
    if [ -z "$NETWORK_OPTION" ]; then
      NETWORK_OPTION="--network $NETWORK"
    fi

    CMD="minikube start --driver $DRIVER --cpus $CPUS --memory $MEMORY $NETWORK_OPTION"
    log_warning "Starting minikuke with the following command:"
    log_warning -e "$CMD"

    $CMD
}

is_minikube_running() {
    minikube status >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        log_info "Minikube is already running"
        return 0
    else
        log_warning "Minikube is not running"
        return 1
    fi
}

run() {
    if [ "$PROVIDER" = "kind" ]; then
      # Checking for required command line utilities
      check_required_utils kind kubectl helm jq

      is_kind_running
      
      if [ $? -ne 0 ]; then
        start_kind
      fi
      
      if [ ! $? -eq 0 ]; then
        log_error "Failed to properly start kind"
        exit 1
      fi
    elif [ "$PROVIDER" = "minikube" ]; then
      # Checking for required command line utilities
      check_required_utils minikube kubectl helm jq

      # Pull in the minikube configuration
      minikube_config

      is_minikube_running
      
      if [ $? -ne 0 ]; then
        start_minikube
      fi
      
      if [ ! $? -eq 0 ]; then
        log_error "Failed to properly start minikube"
        exit 1
      fi
    fi
    
    # Package Installs
    package_config
    install_packages
}

run
