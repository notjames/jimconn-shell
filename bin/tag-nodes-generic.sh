#!/bin/bash

set -e
set -o pipefail

profile=$1
comment="${2:-""}"
tag=gpu

get_machine_ids()
{
  maas "$profile" machines read | \
  jq -Mr --arg profile "$profile" '
  .[] |
    .system_id as $sid |
   select(.owner == "admin" ) |
  @sh "\($sid)"'
}

tag_exists()
{
  local tag=$1

  maas "$profile" tags read | \
    jq -Mr --arg tag "$tag" '[.[] | select(.name == $tag)] | length'
}

while read -r id; do
  a+="add=$id "
done <<< "$(get_machine_ids | tr -d "'")"

echo "Tag: $tag"

if [[ $(tag_exists "$tag") == 0 ]]; then
  # shellcheck disable=SC2086
  echo maas "$profile" tags create name="$tag" comment="$comment" && \
  echo maas "$profile" tag update-nodes "$tag" "$a"
else
  # shellcheck disable=SC2086
  echo maas "$profile" tag update-nodes "$tag" "$a"
fi

