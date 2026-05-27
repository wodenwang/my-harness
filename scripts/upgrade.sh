#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="my-harness"
REPO_SLUG="wodenwang/my-harness"

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
MARKETPLACE_ROOT="$CODEX_HOME/plugins/local/$PLUGIN_NAME"
PLUGIN_ROOT="$MARKETPLACE_ROOT/plugins/$PLUGIN_NAME"
MARKETPLACE_FILE="$MARKETPLACE_ROOT/.agents/plugins/marketplace.json"
CONFIG_FILE="$CODEX_HOME/config.toml"

CHECK_ONLY=0
if [[ "${1:-}" == "--check" ]]; then
  CHECK_ONLY=1
  shift
elif [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
  cat <<'EOF'
Usage:
  scripts/upgrade.sh [--check]

Environment:
  MY_HARNESS_REF          Target tag, branch, or commit. Defaults to latest GitHub Release.
  MY_HARNESS_ARCHIVE_URL  Override source archive URL, mainly for testing.
  CODEX_HOME             Codex home. Defaults to ~/.codex.

Examples:
  scripts/upgrade.sh --check
  MY_HARNESS_REF=v1.0.4 scripts/upgrade.sh
  MY_HARNESS_REF=main scripts/upgrade.sh
EOF
  exit 0
fi

fail() {
  echo "upgrade failed: $*" >&2
  exit 1
}

need_command() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

toml_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

json_read() {
  local file="$1"
  local expression="$2"
  python3 - "$file" "$expression" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
expression = sys.argv[2]
data = json.loads(path.read_text())
value = data
for part in expression.split("."):
    if part.endswith("]"):
        key, index = part[:-1].split("[")
        if key:
            value = value[key]
        value = value[int(index)]
    else:
        value = value[part]
print(value)
PY
}

manifest_version() {
  json_read "$1" "version"
}

changelog_excerpt() {
  local changelog="$1"
  local version="$2"
  [[ -f "$changelog" ]] || return 0
  python3 - "$changelog" "$version" <<'PY'
import re
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text()
version = re.escape(sys.argv[2])
pattern = re.compile(rf"^##\s+{version}\b.*?(?=^##\s+|\Z)", re.M | re.S)
match = pattern.search(text)
if not match:
    raise SystemExit(0)
lines = [line.rstrip() for line in match.group(0).strip().splitlines()]
for line in lines[:14]:
    print(line)
PY
}

resolve_latest_ref() {
  local release_file="$1"
  local tag_file="$2"

  if curl -fsSL "https://api.github.com/repos/$REPO_SLUG/releases/latest" -o "$release_file"; then
    local release_tag
    release_tag="$(python3 - "$release_file" <<'PY'
import json
import sys
from pathlib import Path

try:
    data = json.loads(Path(sys.argv[1]).read_text())
    print(data.get("tag_name", ""))
except Exception:
    print("")
PY
)"
    if [[ -n "$release_tag" ]]; then
      printf '%s\n' "$release_tag"
      return 0
    fi
  fi

  curl -fsSL "https://api.github.com/repos/$REPO_SLUG/tags?per_page=1" -o "$tag_file"
  python3 - "$tag_file" <<'PY'
import json
import sys
from pathlib import Path

data = json.loads(Path(sys.argv[1]).read_text())
if not data:
    raise SystemExit("no releases or tags found")
print(data[0]["name"])
PY
}

ensure_config() {
  mkdir -p "$(dirname "$CONFIG_FILE")"
  touch "$CONFIG_FILE"
  local marketplace_root_toml
  marketplace_root_toml="$(toml_escape "$MARKETPLACE_ROOT")"

  if ! grep -Fq '[plugins."my-harness@my-harness"]' "$CONFIG_FILE"; then
    cat >> "$CONFIG_FILE" <<'TOML'

# My Harness plugin configuration - managed by scripts/upgrade.sh
[plugins."my-harness@my-harness"]
enabled = true
TOML
  fi

  if ! grep -Fq '[marketplaces.my-harness]' "$CONFIG_FILE"; then
    cat >> "$CONFIG_FILE" <<TOML

[marketplaces.my-harness]
source_type = "local"
source = "$marketplace_root_toml"
TOML
  fi
}

write_marketplace() {
  mkdir -p "$(dirname "$MARKETPLACE_FILE")"
  cat > "$MARKETPLACE_FILE" <<'JSON'
{
  "name": "my-harness",
  "interface": {
    "displayName": "My Harness"
  },
  "plugins": [
    {
      "name": "my-harness",
      "source": {
        "source": "local",
        "path": "./plugins/my-harness"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    }
  ]
}
JSON
}

link_skills() {
  local stamp="$1"
  mkdir -p "$CODEX_HOME/skills"
  for skill_dir in "$PLUGIN_ROOT"/skills/*; do
    [[ -d "$skill_dir" ]] || continue
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local target="$CODEX_HOME/skills/$skill_name"
    if [[ -L "$target" ]] || [[ -f "$target" ]]; then
      rm -f "$target"
    elif [[ -d "$target" ]]; then
      mv "$target" "$target.backup.$stamp"
    fi
    ln -s "$skill_dir" "$target"
  done
}

need_command curl
need_command tar
need_command rsync
need_command sed
need_command mktemp
need_command python3
need_command date

[[ -d "$PLUGIN_ROOT" ]] || fail "$PLUGIN_ROOT does not exist. Install $PLUGIN_NAME before upgrading."
[[ -f "$PLUGIN_ROOT/.codex-plugin/plugin.json" ]] || fail "installed plugin is missing .codex-plugin/plugin.json"

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

CURRENT_VERSION="$(manifest_version "$PLUGIN_ROOT/.codex-plugin/plugin.json")"
TARGET_REF="${MY_HARNESS_REF:-}"
TARGET_REF_SOURCE="MY_HARNESS_REF"
if [[ -z "$TARGET_REF" ]]; then
  TARGET_REF="$(resolve_latest_ref "$TMP_DIR/latest-release.json" "$TMP_DIR/latest-tag.json")"
  TARGET_REF_SOURCE="latest GitHub Release/tag"
fi

ARCHIVE_URL="${MY_HARNESS_ARCHIVE_URL:-https://codeload.github.com/$REPO_SLUG/tar.gz/$TARGET_REF}"

echo "My Harness upgrade plan"
echo "  installed plugin: $PLUGIN_ROOT"
echo "  current version:  $CURRENT_VERSION"
echo "  target ref:       $TARGET_REF ($TARGET_REF_SOURCE)"

curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/source.tar.gz"
tar -xzf "$TMP_DIR/source.tar.gz" -C "$TMP_DIR"

SOURCE_DIR="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ -n "$SOURCE_DIR" ]] || fail "could not find extracted source directory"
[[ -f "$SOURCE_DIR/.codex-plugin/plugin.json" ]] || fail "downloaded source is missing .codex-plugin/plugin.json"
[[ -d "$SOURCE_DIR/skills" ]] || fail "downloaded source is missing skills/"
TARGET_VERSION="$(manifest_version "$SOURCE_DIR/.codex-plugin/plugin.json")"

echo "  target version:   $TARGET_VERSION"
if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
  echo "  version change:   no version number change"
else
  echo "  version change:   $CURRENT_VERSION -> $TARGET_VERSION"
fi

if [[ -f "$SOURCE_DIR/CHANGELOG.md" ]]; then
  echo
  echo "Target changelog:"
  changelog_excerpt "$SOURCE_DIR/CHANGELOG.md" "$TARGET_VERSION" || true
fi

if [[ -x "$SOURCE_DIR/scripts/verify.sh" ]]; then
  (cd "$SOURCE_DIR" && ./scripts/verify.sh >/dev/null)
else
  fail "downloaded source is missing executable scripts/verify.sh"
fi

if [[ "$CHECK_ONLY" -eq 1 ]]; then
  echo
  echo "Check only. No files changed."
  exit 0
fi

STAMP="$(date +%Y%m%d%H%M%S)"
BACKUP_DIR="$MARKETPLACE_ROOT/backups/$PLUGIN_NAME-$CURRENT_VERSION-$STAMP"
mkdir -p "$BACKUP_DIR"
rsync -a "$PLUGIN_ROOT/" "$BACKUP_DIR/"

rsync -a --delete --delete-excluded \
  --exclude='.git' \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
  --exclude='.DS_Store' \
  "$SOURCE_DIR/" "$PLUGIN_ROOT/"

write_marketplace
ensure_config
link_skills "$STAMP"

(cd "$PLUGIN_ROOT" && ./scripts/verify.sh >/dev/null)
INSTALLED_VERSION="$(manifest_version "$PLUGIN_ROOT/.codex-plugin/plugin.json")"

echo
echo "Upgraded $PLUGIN_NAME"
echo "  previous version: $CURRENT_VERSION"
echo "  installed version: $INSTALLED_VERSION"
echo "  target ref:        $TARGET_REF"
echo "  backup:            $BACKUP_DIR"
echo "  plugin:            $PLUGIN_ROOT"
echo "  marketplace:       $MARKETPLACE_FILE"
echo "  skills:            $CODEX_HOME/skills/my-harness*"
echo
echo "Restart Codex or refresh skill discovery if the updated skills are not visible yet."
