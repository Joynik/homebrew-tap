#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "::error::Unexpected script failure at line ${LINENO} (${full_name:-initialization})"' ERR

: "${TAP_NAME:?Homebrew tap name is required}"
: "${HOMEBREW_GITHUB_API_TOKEN:?HOMEBREW_TAP_TOKEN secret is required}"
: "${GITHUB_REPOSITORY:?GitHub repository is required}"
: "${GH_TOKEN:?GitHub CLI token is required}"

# GH_TOKEN authenticates gh, not Git; apply its helper to each network command.
git_with_auth() {
  GIT_TERMINAL_PROMPT=0 git -c credential.helper= \
    -c 'credential.helper=!gh auth git-credential' "$@"
}

# Only select the updater's exact branch in this repository, targeting main.
find_update_pr() {
  gh pr list --repo "$GITHUB_REPOSITORY" --state "${2:-open}" --base main \
    --head "$1" --json number,headRefOid,isCrossRepository \
    --jq '[.[] | select(.isCrossRepository == false)] | sort_by(.number) | last | if . == null then empty else [.number, .headRefOid] | @tsv end'
}

failed=0
failed_packages=()
mark_failed() {
  failed=1
  failed_packages+=("$full_name")
}

case "${PACKAGE_KIND:-cask}" in
  cask) directory=Casks ;;
  formula) directory=Formula ;;
  *) echo "::error::PACKAGE_KIND must be cask or formula"; exit 1 ;;
esac
kind="${PACKAGE_KIND:-cask}"
shopt -s nullglob
package_files=("$directory"/*.rb)
if [[ -n "${PACKAGE_NAME:-}" ]]; then
  if [[ ! "$PACKAGE_NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]] || [[ ! -f "$directory/$PACKAGE_NAME.rb" ]]; then
    echo "::error::Unknown $kind: $PACKAGE_NAME"
    exit 1
  fi
  package_files=("$directory/$PACKAGE_NAME.rb")
fi

create_update_pr() (
  set -e
  if [[ "$kind" == cask ]]; then
    brew bump-cask-pr --version="$version" --no-audit --no-style --no-browse --no-fork "$full_name" || exit 1
    return
  fi
  # Isolate changes and cleanup even when a download or validation fails.
  worktree=$(mktemp -d) || exit 1
  trap 'git worktree remove --force "$worktree" >/dev/null 2>&1 || rmdir "$worktree" 2>/dev/null || true' EXIT
  git_with_auth fetch origin main || exit 1
  git worktree add -b "$branch" "$worktree" origin/main || exit 1
  python3 update-packages/formula.py "$worktree/$package_file" "$version" || exit 1
  ruby -c "$worktree/$package_file" || exit 1
  git -C "$worktree" diff --check || exit 1
  git -C "$worktree" add -- "$package_file" || exit 1
  git -C "$worktree" -c user.name='github-actions[bot]' \
    -c user.email='41898282+github-actions[bot]@users.noreply.github.com' \
    commit -m "$package_name $version" || exit 1
  git_with_auth -C "$worktree" push origin "$branch" || exit 1
  gh pr create --repo "$GITHUB_REPOSITORY" --base main --head "$branch" \
    --title "$package_name $version" --body "Update all release archives and SHA256 checksums for $package_name." || exit 1
)

for package_file in "${package_files[@]}"; do
  package_name="${package_file##*/}"
  package_name="${package_name%.rb}"
  full_name="${TAP_NAME}/${package_name}"
  echo "::group::${full_name}"

  if ! result=$(brew livecheck "--$kind" --json "$full_name"); then
    printf '%s\n' "$result"
    echo "::error::Version check failed for ${full_name}"
    mark_failed
  elif ! jq -e 'type == "array" and length == 1 and .[0].version.latest != null and .[0].version.outdated != null' <<<"$result" >/dev/null; then
    echo "$result"
    echo "::error::No valid version result for ${full_name}"
    mark_failed
  elif jq -e '.[0].version.outdated == true' <<<"$result" >/dev/null; then
    version=$(jq -r '.[0].version.latest' <<<"$result")
    if [[ ! "$version" =~ ^[0-9][a-zA-Z0-9.,_+-]*$ ]]; then
      echo "::error::Unsafe or unsupported version: $version"
      mark_failed
      echo "::endgroup::"
      continue
    fi
    branch="bump-${package_name}-${version}"
    if [[ "$kind" == formula ]]; then
      branch="bump-formula-${package_name}-${version}"
    fi
    if ! pr=$(find_update_pr "$branch"); then
      echo "::error::PR lookup failed for ${full_name}"
      mark_failed
      echo "::endgroup::"
      continue
    fi
    # A closed PR can leave its bump branch behind. Reuse it instead of
    # pushing an unrelated new commit to the same branch name.
    if [[ -z "$pr" ]]; then
      if ! closed_pr=$(find_update_pr "$branch" closed); then
        echo "::error::Closed PR lookup failed for ${full_name}"
        mark_failed
        echo "::endgroup::"
        continue
      fi
      if [[ -n "$closed_pr" ]] && [[ -n "$(git_with_auth ls-remote --heads origin "refs/heads/${branch}")" ]]; then
        IFS=$'\t' read -r closed_number closed_sha <<<"$closed_pr"
        echo "Reopening update PR #${closed_number} for ${full_name} ${version}."
        if ! gh pr reopen "$closed_number" --repo "$GITHUB_REPOSITORY"; then
          echo "::error::Could not reopen update PR #${closed_number}"
          mark_failed
          echo "::endgroup::"
          continue
        fi
        pr="$closed_pr"
      fi
    fi
    if [[ -z "$pr" ]] && ! create_update_pr; then
      echo "::error::Update PR failed for ${full_name}"
      mark_failed
      echo "::endgroup::"
      continue
    fi
    if ! pr=$(find_update_pr "$branch") || [[ -z "$pr" ]]; then
      echo "::error::Could not find update PR for ${full_name} ${version}"
      mark_failed
    else
      IFS=$'\t' read -r pr_number head_sha <<<"$pr"
      if merge_output=$(gh pr merge "$pr_number" --repo "$GITHUB_REPOSITORY" \
        --auto --squash --match-head-commit "$head_sha" 2>&1); then
        echo "$merge_output"
        echo "PR #${pr_number}: merge or auto-merge request accepted by GitHub."
      elif [[ "$merge_output" == *"Branch does not have required protected branch rules"* ||
              "$merge_output" == *"Pull request is in clean status"* ]]; then
        echo "Auto-merge is not needed: attempting to merge PR #${pr_number} now."
        if ! gh pr merge "$pr_number" --repo "$GITHUB_REPOSITORY" \
          --squash --match-head-commit "$head_sha"; then
          echo "::error::Could not merge PR #${pr_number}"
          mark_failed
        else
          echo "PR #${pr_number}: merged successfully."
        fi
      else
        echo "$merge_output"
        echo "::error::Could not enable auto-merge for PR #${pr_number}"
        mark_failed
      fi
    fi
  else
    echo "${full_name} is up to date."
  fi

  echo "::endgroup::"
done

if (( failed != 0 )); then
  echo "::error::Package updates failed: ${failed_packages[*]}"
else
  echo "All package updates completed successfully."
fi

exit "$failed"
