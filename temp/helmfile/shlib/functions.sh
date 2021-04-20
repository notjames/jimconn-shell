#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# fix this
declare -a SUPPORTED_ENVS
SUPPORTED_ENVS=("$(find "$BASE_DIR"/../envs -maxdepth 1 -type d | grep -Pv '/envs$')")
REQED=(kubectl readlink)
export SUPPORTED_ENVS

check_reqed()
{
  for r in "${REQED[@]}"; do
    if ! which "$r" > /dev/null 2>&1; then
      echo >&2 "Required application '$r' is either not present or not found in your \$PATH"
      return 1
    fi
  done
}

# check_supported_env: make sure something is running in the correct
# environment
check_supported_env() 
{
  local deploy_env found_env

  deploy_env=$1
  found_env=false

  for env in "${SUPPORTED_ENVS[@]}"; do
    s_env=${env##*/}
    if [ "$deploy_env" == "$s_env" ]; then
      found_env=true
    fi
  done

  if [ "$found_env" == "false" ]; then
    echo 
    """
    The environment '$deploy_env' is invalid
    You must use one of: 
    ${SUPPORTED_ENVS[*]}
    """
    exit 1
  fi
}

# apply_crd: apply kubernetes crds
apply_crd()
{
  if [[ "$#" -lt 3 ]]; then
    echo "Usage: apply_crd <helmfile env> <kube context> <crd path>"
    exit 1
  fi

  check_supported_env "$1"

  kubectl apply --kubeconfig="$(readlink -n -f env/"$1"/values/kubeconfig) --context=$2 \
    --overwrite=true --validate=false -f $(readlink -n -f "$3")"
}

# apply_manifest: kubectl apply a normal file manifest
apply_manifest()
{
  if [[ "$#" -lt 3 ]]; then
    echo "Usage: apply_manifest <helmfile env> <kube context> <manifest path> [namespace] "
    exit 1
  fi

  check_supported_env "$1"

  if [[ -z "$4" ]]; then 
    kubectl apply --kubeconfig="$(readlink -n -f env/"$1"/values/kubeconfig)" \
      --context="$2" --overwrite=true -f "$(readlink -n -f "$3")"
  else 
    kubectl apply --kubeconfig="$(readlink -n -f env/"$1"/values/kubeconfig)" \
      --context="$2" --namespace="$4" --overwrite=true -f "$(readlink -n -f "$3")"
  fi
}

# apply_patch to kubernetes resource
apply_patch()
{
  if [[ "$#" -le 2 ]]; then
    echo "Usage: apply_patch <helmfile env> <kube context> <k8s object type (deployment pod," \
         "etc)> <object name> <yaml patch file name> [namespace]"
    exit 1
  fi

  check_supported_env "$1"

  if [[ -z "$6" ]]; then 
    kubectl --kubeconfig="$(readlink -n -f env/"$1"/values/kubeconfig)" \
      --context="$2" patch "$3" "$4" --patch "$(cat "$(readlink -n -f "$5")")"
  else
    kubectl --kubeconfig="$(readlink -n -f env/"$1"/values/kubeconfig)" \
      --context="$2" --namespace="$6" patch "$3" "$4" --patch "$(cat "$(readlink -n -f "$5")")"
  fi
}

# create kubernetes namespace
create_ns()
{
  if [[ "$#" -ne 3 ]]; then
    echo "Usage: create_ns <helmfile env> <kube context> <namespace> "
    exit 1
  fi

  check_supported_env "$1"

  cat <<E | kubectl apply --kubeconfig="$(readlink -n -f env/"$1"/values/kubeconfig)" --context="$2" -f -
apiVersion: v1
kind: Namespace
metadata:
  name: $3
E
}

# use this to bootstrap secrets for the helmfile run
bootstrap_secrets()
{
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: $(basename "$0") environment name"
    exit 1
  fi

  check_supported_env "$1"

  #sops -d env/"$1"/secrets/kubeconfig.yaml > env/"$1"/values/kubeconfig

  # need to get aws credentials and
  # use those to get kubeconfig
  # set KMS_ARN for sops
}

# sops_decrypt_secrets: decrypts secrets stored in SCM
sops_decrypt_secrets()
{
  local bootstrap_root enc_src_path

  if [[ "$#" -ne 1 ]]; then
    echo "Usage: $(basename "$0") <path to resource>"
    exit 1
  fi

  bootstrap_root="$(cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
  enc_src_path="$(readlink -n -f "$1")"

  mkdir -p "$bootstrap_root"/temp

  shred -n 5 -zu "$bootstrap_root"/temp/"$(basename "$enc_src_path")"/*
  rm -rf "$bootstrap_root"/temp/"$(basename "$enc_src_path")"

  sops -d "$enc_src_path" > "$bootstrap_root"/temp/"$(basename "$enc_src_path")"
}
