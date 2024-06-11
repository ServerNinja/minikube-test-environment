#!/usr/bin/env bash
export GREEN=`tput setaf 2`
export YELLOW=`tput setaf 3`
export RED=`tput setaf 1`
export RESET=`tput sgr0`

log_info() {
  echo -e "$GREEN[INFO]: $@ $RESET"
}

log_warning() {
  echo -e "$YELLOW[WARN]: $@ $RESET"
}

log_error() {
  echo -e "$RED[ERROR]: $@ $RESET"
}

install_helm_chart() {
    # Check if the helm release exists
    if ! helm list -n $NAMESPACE | grep -q $HELM_RELEASE; then
        # Check if helm repo exists
        if [[ $HELM_REPO != oci://* ]]; then
            CHART_STRING="$REPO_NAME/$HELM_CHART"
            if ! helm repo list | grep -q "$HELM_RELEASE"; then
                # Add helm repo
                log_info "Adding $REPO_NAME helm repo..."
                helm repo add $REPO_NAME $HELM_REPO
      
                # Update helm repos
                log_info "Updating helm repos..."
                helm repo update
            fi
        else
            CHART_STRING="$HELM_REPO/$HELM_CHART"
        fi
    
        # Install the helm release
        log_info "Installing $HELM_CHART helm chart..."
    
        if [ ! -z "$HELM_VALUES" ]; then
          HELM_VALUES_STRING="--values \"$HELM_VALUES\""
        fi

        if [ ! -z "$HELM_CHART_VERSION" ]; then
          HELM_VERSION_STRING="--version $HELM_CHART_VERSION"
        fi

        helm upgrade --install $HELM_RELEASE \
          -n $NAMESPACE \
          --create-namespace \
          $CHART_STRING $HELM_VALUES_STRING $HELM_VERSION_STRING
    else
        log_info "Helm chart: \"$HELM_CHART\" is already installed in $NAMESPACE namespace."
    fi
}

check_required_utils() {
    local required_utils="$@"
    local missing_utils=""

    for util in $required_utils; do
        if ! command -v $util &> /dev/null; then
          missing_utils="$missing_utils $util"
        fi
    done

    if [ "$missing_utils" != "" ]; then
        log_error "Missing required utilities. Please install:$missing_utils"
        exit 1
    fi
}