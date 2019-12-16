#!/bin/bash

declare -A FINGERPRINTS

fingerprint()
{
  echo "$*" | md5sum | awk '{print $1}'
}

ARR=(this table_name is just a table_name test)

for key in "${ARR[@]}"; do
  if [[ "$key" != table_name ]]
  then
    FINGERPRINTS+=([$key]="$(fingerprint "$key")")
  fi
done

for k in "${!FINGERPRINTS[@]}"; do
  echo "key is $k: FINGERPRINT[$k]: ${FINGERPRINTS[$k]}"
done
