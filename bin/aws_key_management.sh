#!/bin/bash
# Author: Jim Conner <snafu.x _ gee mail + com

_aws_prep_for_new_key()
{
  if [[ -f "$private_key" ]] && ! shred -z -n5 -u "${private_key}" 2>/dev/null; then
    return 1
  fi

  if ! touch "${private_key}"; then
    echo >&2 "Unable to create (touch) new keyfile: ${private_key}"
    return 1
  fi

  if ! chmod 0600 "${private_key}"; then
    echo >&2 "Unable to chmod 0600 ${private_key}"
    return 1
  fi
}

_aws_get_key_fp()
{
  aws ec2 describe-key-pairs --key-name "${key_name}" \
                             --query "KeyPairs[].KeyFingerprint"
                             --output text
}

_aws_local_key_fp()
{
  openssl pkcs8 -in "${key_name}" -inform PEM -outform DER -topk8 \
                -nocrypt 2>/dev/null | \
                openssl sha1 -c | awk '{print $2}'
}

aws_delete_key()
{
  local key_name

  key_name=$1

  [[ -z "${key_name}" ]] && \
    {
      echo >&2 "Usage: aws_delete_key(): requires the name of the key to check for in AWS."
      return 1
    }

  aws ec2 delete-key-pair --key-name "${key_name}"
}

aws_create_key()
{
  local key_name
  key_name=$1

  [[ -z "${key_name}" ]] && \
    {
      echo >&2 "Usage: aws_create_key(): requires the name of the key to check for in AWS."
      return 1
    }

  if ! _aws_prep_for_new_key; then
    return 1
  fi

  if ! aws ec2 create-key-pair  \
      --key-name "${key_name}" \
      --query 'KeyMaterial'    \
      --output text >> "${private_key}"; then
    _aws_own "${private_key}"
    return 1
  fi
}

_aws_key_exists()
{
  local key_name
  key_name=$1

  [[ -z "${key_name}" ]] && \
    {
      echo >&2 "Usage: _aws_key_exists(): requires the name of the key to check for in AWS."
      return 1
    }

  # shellcheck disable=SC2027,SC2086
  aws ec2 describe-key-pairs --query "KeyPairs[? KeyName == '"${key_name}"'] | length(@)"
}

_aws_own()
{
  [[ -z $1 ]] && return
  # shellcheck disable=SC2046
  chown $(stat -c '%u:%g' "$key_home") "$1"
}

## This is the public function.
aws_key_material()
{
  key_name=${KEY_NAME:-$1}

  if [[ -z "$key_name" ]]; then
    echo >&2 '$key_name must be set to get a new key created and a base64 encoded ' \
             'key or no argument for keyname specified!'
    return 1
  fi

  if [[ $USER == "root" ]]; then
    # for docker containers in case $HOME doesn't work.
    KEY_HOME="/root/.ssh"
  else
    KEY_HOME="${KEY_HOME:-${HOME}/.ssh}"
  fi

  key_home="${KEY_HOME}"
  key_name+="Key"
  base_key_name="${key_home}/${key_name}"
  private_key="$base_key_name.pem"
  public_key="$base_key_name.pub"
  pk_base64="$base_key_name.b64"

  if [[ $(_aws_key_exists "${key_name}") -gt 0 ]]; then
    aws_delete_key "${key_name}"
  fi

  if [[ -s ${private_key} ]]; then
    ssh-keygen -t rsa -C "${key_name}" -yf "${private_key}" > "${public_key}"
    _aws_own "$public_key"

    if ! aws ec2 import-key-pair \
        --key-name "${key_name}" \
        --public-key-material file://"${public_key}"; then

      if ! aws_create_key "${key_name}"; then
        echo >&2 "Error creating/importing key material."
        return 1
      fi
    fi
  else
    if ! aws_create_key "${key_name}"; then
      echo >&2 "Error creating/importing key material."
      return 1
    fi
    echo "New key created!"
  fi

  _aws_b64_encoded_key
}

# this is a public function.
_aws_b64_encoded_key()
{
  if [[ $USER == "root" ]]; then
    # for docker containers in case $HOME doesn't work.
    KEY_HOME="/root/.ssh"
  else
    KEY_HOME="${KEY_HOME:-${HOME}/.ssh}"
  fi

  if [[ ! -f $pk_base64 ]] || [[ ! -s $pk_base64 ]]; then
    < "$private_key" base64 | tr -d '\r\n' | tr -d ' ' > "$pk_base64"

    if [[ -s $pk_base64 ]]; then
      chmod 600 "$pk_base64" "$private_key"
      _aws_own "$pk_base64"
    else
      echo >&2 "Creation of base64 encoded private key failed!"
      return 1
    fi
  fi

  if [[ -n $pk_base64 && -s $pk_base64 ]]; then
    CLUSTER_PRIVATE_KEY=$(< "$pk_base64")
    export CLUSTER_PRIVATE_KEY
  else
    echo >&2 "Unfortunately, \$pk_base64 is not set or '$pk_base64' is non-existent."
    return 1
  fi
}
