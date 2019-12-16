#!/bin/bash

set -e

profile=jimconn

get_machine_ids()
{
  maas $profile machines list-allocated | \
  jq -Mr --arg profile $profile '
  .[] |
  .resource_uri as $rid |
  .system_id as $sid |
   select(.owner == $profile ) |
   .owner_data |
    select(."juju-is-controller"?) |= . + {"juju-machine-id": $sid, "juju-units-deployed":"juju-controller"} |
    select(."juju-units-deployed" == null) |= . + {"juju-units-deployed":"default-machine"} |
  @sh "\($sid) \(."juju-units-deployed")"'
}

tag_exists()
{
  local tag=$1

  maas $profile tags read | \
    jq -Mr --arg tag "$tag" '[.[] | select(.name == $tag)] | length'
}

while read -r id tag; do
  tag=${tag/\//-}
  echo "Tag: $id -> $tag"

  if [[ $(tag_exists "$tag") == 0 ]]; then
    # shellcheck disable=SC2086
    maas "$profile" tags create name="$tag" comment="juju machine resource name" && \
    maas "$profile" tag update-nodes "$tag" add="$id"
  else
    # shellcheck disable=SC2086
    maas "$profile" tag update-nodes "$tag" add="$id"
  fi
done <<< "$(get_machine_ids | tr -d "'")"
