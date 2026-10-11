#!/usr/bin/env bash
set -euo pipefail

: "${TAP_NAME:?Homebrew tap name is required}"
: "${HOMEBREW_GITHUB_API_TOKEN:?HOMEBREW_TAP_TOKEN secret is required}"
: "${GITHUB_REPOSITORY:?GitHub repository is required}"
: "${GH_TOKEN:?GitHub CLI token is required}"

# Only select the updater's exact branch in this repository, targeting main.
find_update_pr() {
  gh pr list --repo "$GITHUB_REPOSITORY" --state "${2:-open}" --base main \
    --head "$1" --json number,headRefOid,isCrossRepository \
    --jq '[.[] | select(.isCrossRepository == false)] | sort_by(.number) | last | if . == null then empty else [.number, .headRefOid] | @tsv end'
}

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
    branch="bump-${cask_name}-${version}"
    if ! pr=$(find_update_pr "$branch"); then
      echo "::error::PR lookup failed for ${full_name}"
      failed=1
      echo "::endgroup::"
      continue
    fi
    # A closed PR can leave its bump branch behind. Reuse it instead of
    # pushing an unrelated new commit to the same branch name.
    if [[ -z "$pr" ]]; then
      if ! closed_pr=$(find_update_pr "$branch" closed); then
        echo "::error::Closed PR lookup failed for ${full_name}"
        failed=1
        echo "::endgroup::"
        continue
      fi
      if [[ -n "$closed_pr" ]] && [[ -n "$(git ls-remote --heads origin "refs/heads/${branch}")" ]]; then
        IFS=$'\t' read -r closed_number closed_sha <<<"$closed_pr"
        echo "Reopening update PR #${closed_number} for ${full_name} ${version}."
        if ! gh pr reopen "$closed_number" --repo "$GITHUB_REPOSITORY"; then
          echo "::error::Could not reopen update PR #${closed_number}"
          failed=1
          echo "::endgroup::"
          continue
        fi
        pr="$closed_pr"
      fi
    fi
    if [[ -z "$pr" ]] && ! brew bump-cask-pr --version="$version" --no-audit --no-style --no-browse --no-fork "$full_name"; then
      echo "::error::Update PR failed for ${full_name}"
      failed=1
      echo "::endgroup::"
      continue
    fi
    if ! pr=$(find_update_pr "$branch") || [[ -z "$pr" ]]; then
      echo "::error::Could not find update PR for ${full_name} ${version}"
      failed=1
    else
      IFS=$'\t' read -r pr_number head_sha <<<"$pr"
      if merge_output=$(gh pr merge "$pr_number" --repo "$GITHUB_REPOSITORY" \
        --auto --squash --match-head-commit "$head_sha" 2>&1); then
        echo "$merge_output"
      elif [[ "$merge_output" == *"Branch does not have required protected branch rules"* ]]; then
        echo "No required branch rules: merging PR #${pr_number} now."
        if ! gh pr merge "$pr_number" --repo "$GITHUB_REPOSITORY" \
          --squash --match-head-commit "$head_sha"; then
          echo "::error::Could not merge PR #${pr_number}"
          failed=1
        fi
      else
        echo "$merge_output"
        echo "::error::Could not enable auto-merge for PR #${pr_number}"
        failed=1
      fi
    fi
  else
    echo "${full_name} is up to date."
  fi

  echo "::endgroup::"
done

exit "$failed"
