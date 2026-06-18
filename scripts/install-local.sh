#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
MARKETPLACE_ROOT="$CODEX_HOME/plugins/local/my-harness"
PLUGIN_ROOT="$MARKETPLACE_ROOT/plugins/my-harness"
MARKETPLACE_FILE="$MARKETPLACE_ROOT/.agents/plugins/marketplace.json"

mkdir -p "$PLUGIN_ROOT" "$(dirname "$MARKETPLACE_FILE")" "$CODEX_HOME/skills"

rsync -a --delete --delete-excluded \
  --exclude='.git' \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
  --exclude='.DS_Store' \
  "$ROOT/" "$PLUGIN_ROOT/"

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
for target in "$CODEX_HOME"/skills/my-harness*; do
  [[ -e "$target" || -L "$target" ]] || continue
  skill_name="$(basename "$target")"
  [[ ! -f "$PLUGIN_ROOT/skills/$skill_name/SKILL.md" ]] || continue
  if [[ -L "$target" ]] || [[ -f "$target" ]]; then
    rm -f "$target"
  elif [[ -d "$target" ]]; then
    mv "$target" "$target.backup.$STAMP"
  fi
done

for skill_dir in "$PLUGIN_ROOT"/skills/*; do
  [[ -f "$skill_dir/SKILL.md" ]] || continue
  skill_name="$(basename "$skill_dir")"
  ln -sfn "$skill_dir" "$CODEX_HOME/skills/$skill_name"
done

cat <<EOF
installed my-harness plugin:
  $PLUGIN_ROOT

marketplace:
  $MARKETPLACE_FILE

global skill symlinks:
  $CODEX_HOME/skills/my-harness*

If Codex config does not already enable this plugin, add:

[plugins."my-harness@my-harness"]
enabled = true

[marketplaces.my-harness]
source = "$MARKETPLACE_ROOT"
EOF
