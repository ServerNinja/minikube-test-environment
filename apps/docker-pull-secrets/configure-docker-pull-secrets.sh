#!/usr/bin/env bash
REPO=https://ghcr.io

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$BASEDIR/../.lib/common.sh"

if kubectl get secret ghcr-login-secret >/dev/null 2>&1; then
    log_info "The ghcr-login-secret already exists..."
    exit 0
fi

log_info "If not configuring pull secrets, just press enter."
read -p "Enter your GitHub username: " GITHUB_USER

if [[ -z "$GITHUB_USER" ]]; then
    log_warning "Username appears to be blank. Will not continue with configuring pull secrets."
    exit 0
fi

read -s -p "Enter your GitHub password: " GITHUB_PASS
echo

log_info "Configuring pull secrets..."

kubectl create secret docker-registry ghcr-login-secret \
  --docker-server=$REPO \
  --docker-username=$GITHUB_USER \
  --docker-password=$GITHUB_PASS