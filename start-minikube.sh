#!/usr/bin/env bash
# Read values from config.json using jq
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Import common functions
. "$BASEDIR/.lib/common.sh"

# Checking for required command line utilities
check_required_utils minikube kubectl helm jq

# Pulling config ffrom config.json
export MEMORY="$(jq -r '.minikube.memory' "$BASEDIR/config.json")"
export CPUS="$(jq -r '.minikube.cpus' "$BASEDIR/config.json")"
export DRIVER="$(jq -r '.minikube.driver' "$BASEDIR/config.json")"
export NETWORK="$(jq -r '.minikube.network' "$BASEDIR/config.json")"

show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -m    Enable monitoring components"
  echo "  -d    Enable MySQL installation"
  echo "  -h    Show this help message"
}

start_minikube() {
    if [ ! -z "$NETWORK_OPTION" ]; then
      NETWORK_OPTION="--network $NETWORK"
    fi

    CMD="minikube start --driver $DRIVER --cpus $CPUS --memory $MEMORY $NETWORK_OPTION"
    echo "Starting minikuke with the following command:"
    echo -e "$CMD"

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
    is_minikube_running
    
    if [ $? -ne 0 ]; then
      start_minikube
    fi
    
    if [ ! $? -eq 0 ]; then
      log_error "Failed to properly start minikube"
      exit 1
    fi
    
    $BASEDIR/docker-pull-secrets/configure-docker-pull-secrets.sh
    $BASEDIR/reflector/configure-reflector.sh
    $BASEDIR/bank-vaults/configure-bank-vaults.sh

    # Install monitoring components if enabled
    if [ "$MONITORING" = "true" ]; then
      $BASEDIR/prometheus/configure-prometheus.sh
      $BASEDIR/loki/configure-loki.sh
      $BASEDIR/logging-operator/configure-logging-operator.sh
      $BASEDIR/grafana/configure-grafana.sh
    fi
    
    # Install MySQL if enabled
    if [ "$MYSQL" = "true" ]; then
      $BASEDIR/bitnami-mysql/configure-mysql.sh
    fi
}

# Get options
while getopts ":mdh" opt; do
  case $opt in
    m)
      export MONITORING=true
      ;;
    d)
      export MYSQL=true
      ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

run
