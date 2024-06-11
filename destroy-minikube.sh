#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/.lib/common.sh"

check_required_cmds

log_warning "Destroying minikube instance..."

minikube delete
