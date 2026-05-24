#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
MARKETPLACE_ROOT="$CODEX_HOME/plugins/local/my-harness"
PLUGIN_ROOT="$MARKETPLACE_ROOT/plugins/my-harness"
MARKETPLACE_FILE="$MARKETPLACE_ROOT/.agents/plugins/marketplace.json"

mkdir -p "$PLUGIN_ROOT" "$(dirname "$MARKETPLACE_FILE")" "$CODEX_HOME/skills"

rsync -a --delete \
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

for skill_dir in "$PLUGIN_ROOT"/skills/*; do
  [[ -d "$skill_dir" ]] || continue
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
