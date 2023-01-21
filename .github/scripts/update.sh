#!/usr/bin/env bash

MINIFLUX_URL="https://api.github.com/repos/miniflux/v2/releases"

FULL_LAST_VERSION=$(curl -SsL ${MINIFLUX_URL} | jq -c '.[] | select( .prerelease == false )'  | jq .name -r | head -1 )
LAST_VERSION="${FULL_LAST_VERSION}"

sed -i -e "s|MINIFLUX_URL_VERSION='.*'|MINIFLUX_URL_VERSION='${LAST_VERSION}'|" Dockerfile*

if output=$(git status --porcelain) && [ -z "$output" ]; then
  # Working directory clean
  echo "No new version available!"
else 
  # Uncommitted changes
  git commit -a -m "update to version: ${LAST_VERSION}"
  git push
fi
