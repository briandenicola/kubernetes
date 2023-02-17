#!/usr/bin/env bash
set -euo pipefail

dump-ip() {
  echo You will find the service at: $1
}

update-templates() {
  
  export TENANT_ID=$1
  export CLIENT_ID=$2
  export WORKLOAD_IDENTITY=$3

  envsubst < manifests/templates/serviceaccount.tmpl > manifests/overlays/serviceaccount.yaml
  envsubst < manifests/templates/deployment.tmpl > manifests/overlays/deployment.yaml

}

random_string() {
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-8} | head -n 1 | tr '[:upper:]' '[:lower:]'
}

# Call the requested function and pass the arguments as-is
"$@"



