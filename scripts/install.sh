#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="my-harness"
DEFAULT_REF="v1.0.6"
REPO_SLUG="wodenwang/my-harness"

MY_HARNESS_REF="${MY_HARNESS_REF:-$DEFAULT_REF}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
MARKETPLACE_ROOT="$CODEX_HOME/plugins/local/$PLUGIN_NAME"
PLUGIN_ROOT="$MARKETPLACE_ROOT/plugins/$PLUGIN_NAME"
MARKETPLACE_FILE="$MARKETPLACE_ROOT/.agents/plugins/marketplace.json"
CONFIG_FILE="$CODEX_HOME/config.toml"
ARCHIVE_URL="${MY_HARNESS_ARCHIVE_URL:-https://codeload.github.com/$REPO_SLUG/tar.gz/$MY_HARNESS_REF}"

fail() {
  echo "install failed: $*" >&2
  exit 1
}

need_command() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

toml_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

need_command curl
need_command tar
need_command rsync
need_command sed
need_command mktemp
need_command python3

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$PLUGIN_ROOT" "$(dirname "$MARKETPLACE_FILE")" "$CODEX_HOME/skills" "$(dirname "$CONFIG_FILE")"

echo "Installing $PLUGIN_NAME from $REPO_SLUG@$MY_HARNESS_REF"
curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/source.tar.gz"
tar -xzf "$TMP_DIR/source.tar.gz" -C "$TMP_DIR"

SOURCE_DIR="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ -n "$SOURCE_DIR" ]] || fail "could not find extracted source directory"
[[ -f "$SOURCE_DIR/.codex-plugin/plugin.json" ]] || fail "downloaded source is missing .codex-plugin/plugin.json"
[[ -d "$SOURCE_DIR/skills" ]] || fail "downloaded source is missing skills/"

rsync -a --delete --delete-excluded \
  --exclude='.git' \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
  --exclude='.DS_Store' \
  "$SOURCE_DIR/" "$PLUGIN_ROOT/"

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

STAMP="$(date +%Y%m%d%H%M%S)"
for skill_dir in "$PLUGIN_ROOT"/skills/*; do
  [[ -d "$skill_dir" ]] || continue
  skill_name="$(basename "$skill_dir")"
  target="$CODEX_HOME/skills/$skill_name"
  if [[ -L "$target" ]] || [[ -f "$target" ]]; then
    rm -f "$target"
  elif [[ -d "$target" ]]; then
    mv "$target" "$target.backup.$STAMP"
  fi
  ln -s "$skill_dir" "$target"
done

touch "$CONFIG_FILE"
MARKETPLACE_ROOT_TOML="$(toml_escape "$MARKETPLACE_ROOT")"

config_changed=0
if ! grep -Fq '[plugins."my-harness@my-harness"]' "$CONFIG_FILE"; then
  cat >> "$CONFIG_FILE" <<'TOML'

# My Harness plugin configuration - managed by scripts/install.sh
[plugins."my-harness@my-harness"]
enabled = true
TOML
  config_changed=1
fi

if ! grep -Fq '[marketplaces.my-harness]' "$CONFIG_FILE"; then
  cat >> "$CONFIG_FILE" <<TOML

[marketplaces.my-harness]
source_type = "local"
source = "$MARKETPLACE_ROOT_TOML"
TOML
  config_changed=1
fi

if [[ -x "$PLUGIN_ROOT/scripts/verify.sh" ]]; then
  (cd "$PLUGIN_ROOT" && ./scripts/verify.sh >/dev/null)
fi

echo
echo "Installed $PLUGIN_NAME"
echo "  plugin:      $PLUGIN_ROOT"
echo "  marketplace: $MARKETPLACE_FILE"
echo "  skills:      $CODEX_HOME/skills/my-harness*"
echo "  config:      $CONFIG_FILE"
if [[ "$config_changed" -eq 1 ]]; then
  echo
  echo "Updated Codex config. Restart Codex or refresh skill discovery if the plugin is not visible yet."
else
  echo
  echo "Codex config already had my-harness entries. Restart Codex or refresh skill discovery if needed."
fi
