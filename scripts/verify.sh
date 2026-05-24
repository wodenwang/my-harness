#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  echo "verify failed: $*" >&2
  exit 1
}

python3 - <<'PY'
import json
from pathlib import Path

root = Path.cwd()
manifest_path = root / ".codex-plugin" / "plugin.json"
data = json.loads(manifest_path.read_text())

required = ["name", "version", "description", "skills", "interface"]
missing = [key for key in required if key not in data]
if missing:
    raise SystemExit(f"missing manifest fields: {missing}")

if data["name"] != "my-harness":
    raise SystemExit("manifest name must be my-harness")

if data["skills"] != "./skills/":
    raise SystemExit("manifest skills path must be ./skills/")

print("manifest ok")
PY

required_skills=(
  "my-harness"
  "my-harness-next-action"
  "my-harness-writing-design"
  "my-harness-autopilot-slice"
)

for skill in "${required_skills[@]}"; do
  file="skills/$skill/SKILL.md"
  [[ -f "$file" ]] || fail "missing $file"
  rg -n "^name: $skill$" "$file" >/dev/null || fail "$file frontmatter name mismatch"
  rg -n "^description: Use when " "$file" >/dev/null || fail "$file description must start with 'Use when'"
done

if find . \( -name '__pycache__' -o -name '*.pyc' \) -print -quit | rg . >/dev/null; then
  find . \( -name '__pycache__' -o -name '*.pyc' \) -print >&2
  fail "generated Python cache artifacts are present"
fi

echo "skills ok"
echo "verify ok"
