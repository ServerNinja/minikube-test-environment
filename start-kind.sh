#!/usr/bin/env bash
# Read values from config.json using jq
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Import common functions
. "$BASEDIR/.lib/common.sh"

# Checking for required command line utilities
check_required_utils kind kubectl helm jq

show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -m    Enable monitoring components"
  echo "  -d    Enable MySQL installation"
  echo "  -h    Show this help message"
}

start_kind() {
    CMD="kind create cluster"
    echo "Starting kind with the following command:"
    echo -e "$CMD"

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

run() {
    is_kind_running
    
    if [ $? -ne 0 ]; then
      start_kind
    fi
    
    if [ ! $? -eq 0 ]; then
      log_error "Failed to properly start kind"
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
