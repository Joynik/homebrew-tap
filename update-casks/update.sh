#!/usr/bin/env bash
set -euo pipefail

: "${TAP_NAME:?Homebrew tap name is required}"
: "${HOMEBREW_GITHUB_API_TOKEN:?HOMEBREW_TAP_TOKEN secret is required}"

failed=0
for cask_file in Casks/*.rb; do
  cask_name="${cask_file##*/}"
  cask_name="${cask_name%.rb}"
  full_name="${TAP_NAME}/${cask_name}"
  echo "::group::${full_name}"

  if ! result=$(brew livecheck --cask --json "$full_name"); then
    echo "::error::Version check failed for ${full_name}"
    failed=1
  elif ! jq -e 'type == "array" and length == 1 and .[0].version.latest != null and .[0].version.outdated != null' <<<"$result" >/dev/null; then
    echo "$result"
    echo "::error::No valid version result for ${full_name}"
    failed=1
  elif jq -e '.[0].version.outdated == true' <<<"$result" >/dev/null; then
    version=$(jq -r '.[0].version.latest' <<<"$result")
    if ! brew bump-cask-pr --version="$version" --no-audit --no-style --no-browse --no-fork "$full_name"; then
      echo "::error::Update PR failed for ${full_name}"
      failed=1
    fi
  else
    echo "${full_name} is up to date."
  fi

  echo "::endgroup::"
done

exit "$failed"
