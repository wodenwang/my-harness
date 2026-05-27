#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MODE="${1:-}"
REPO_SLUG="${REPO_SLUG:-wodenwang/my-harness}"

fail() {
  echo "release lineage check failed: $*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage:
  scripts/check-release-lineage.sh --pre-release
  scripts/check-release-lineage.sh --post-release

Environment:
  TARGET_TAG  Override the expected tag. Defaults to v<manifest version>.
  REPO_SLUG   GitHub repository slug for release checks. Defaults to wodenwang/my-harness.
EOF
}

manifest_version() {
  python3 - <<'PY'
import json
from pathlib import Path

print(json.loads(Path(".codex-plugin/plugin.json").read_text())["version"])
PY
}

remote_tag_exists() {
  local tag="$1"
  git ls-remote --tags origin "$tag" "$tag^{}" | grep -q .
}

local_tag_exists() {
  local tag="$1"
  git rev-parse -q --verify "refs/tags/$tag" >/dev/null
}

latest_prior_stable_tag() {
  local target="$1"
  local tag
  while IFS= read -r tag; do
    [[ "$tag" == "$target" ]] && continue
    [[ "$tag" == *-* ]] && continue
    printf '%s\n' "$tag"
    return 0
  done < <(git tag --list 'v[0-9]*.[0-9]*.[0-9]*' --sort=-v:refname)
  return 1
}

require_git_ref() {
  local ref="$1"
  git rev-parse --verify "$ref" >/dev/null 2>&1 || fail "missing git ref: $ref"
}

if [[ "$MODE" == "-h" || "$MODE" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "$MODE" != "--pre-release" && "$MODE" != "--post-release" ]]; then
  usage >&2
  fail "expected --pre-release or --post-release"
fi

VERSION="$(manifest_version)"
TARGET_TAG="${TARGET_TAG:-v$VERSION}"
PREVIOUS_TAG="$(latest_prior_stable_tag "$TARGET_TAG")" || fail "could not find previous stable tag before $TARGET_TAG"

require_git_ref "origin/main"
require_git_ref "$PREVIOUS_TAG"

git merge-base --is-ancestor origin/main HEAD || fail "origin/main must be an ancestor of the current HEAD"
git merge-base --is-ancestor "$PREVIOUS_TAG" HEAD || fail "current HEAD must contain previous stable tag $PREVIOUS_TAG"

case "$MODE" in
  --pre-release)
    if local_tag_exists "$TARGET_TAG"; then
      fail "local tag $TARGET_TAG already exists before release"
    fi
    if remote_tag_exists "$TARGET_TAG"; then
      fail "remote tag $TARGET_TAG already exists before release"
    fi
    echo "release lineage pre-release ok"
    ;;
  --post-release)
    local_tag_exists "$TARGET_TAG" || fail "local tag $TARGET_TAG must exist after release"
    remote_tag_exists "$TARGET_TAG" || fail "remote tag $TARGET_TAG must exist after release"
    git merge-base --is-ancestor "$TARGET_TAG" HEAD || fail "current HEAD must contain released tag $TARGET_TAG"
    command -v gh >/dev/null 2>&1 || fail "gh is required for post-release GitHub Release verification"
    gh release view "$TARGET_TAG" --repo "$REPO_SLUG" >/dev/null || fail "GitHub Release $TARGET_TAG not found in $REPO_SLUG"
    echo "release lineage post-release ok"
    ;;
esac
