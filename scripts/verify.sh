#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  echo "verify failed: $*" >&2
  exit 1
}

MANIFEST_VERSION="$(
python3 - <<'PY'
import json
import re
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

version = data["version"]
semver = r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$"
if not re.match(semver, version):
    raise SystemExit(f"manifest version must be semver-compatible, got {version}")

print(version)
PY
)" || fail "manifest validation failed"
MANIFEST_REF="v$MANIFEST_VERSION"

echo "manifest ok ($MANIFEST_VERSION)"

[[ -x scripts/install.sh ]] || fail "scripts/install.sh must exist and be executable"
[[ -x scripts/upgrade.sh ]] || fail "scripts/upgrade.sh must exist and be executable"
[[ -x scripts/check-release-lineage.sh ]] || fail "scripts/check-release-lineage.sh must exist and be executable"
[[ -f scripts/install.ps1 ]] || fail "scripts/install.ps1 must exist for Windows installs"
[[ -f scripts/upgrade.ps1 ]] || fail "scripts/upgrade.ps1 must exist for Windows upgrades"

CHANGELOG_PATTERN="^## ${MANIFEST_VERSION//./\\.}\\b"
rg -n "$CHANGELOG_PATTERN" CHANGELOG.md >/dev/null || fail "CHANGELOG.md must contain section for $MANIFEST_VERSION"

grep -Fq "DEFAULT_REF=\"$MANIFEST_REF\"" scripts/install.sh || fail "scripts/install.sh DEFAULT_REF must be $MANIFEST_REF"
grep -Fq "\$DefaultRef = \"$MANIFEST_REF\"" scripts/install.ps1 || fail "scripts/install.ps1 DefaultRef must be $MANIFEST_REF"
grep -Fq "MY_HARNESS_REF=$MANIFEST_REF scripts/upgrade.sh" scripts/upgrade.sh || fail "scripts/upgrade.sh help example must use $MANIFEST_REF"

grep -Fq "raw.githubusercontent.com/wodenwang/my-harness/$MANIFEST_REF/scripts/install.sh" README.md || fail "README macOS/Linux install example must use $MANIFEST_REF"
grep -Fq "raw.githubusercontent.com/wodenwang/my-harness/$MANIFEST_REF/scripts/install.ps1" README.md || fail "README Windows install example must use $MANIFEST_REF"
grep -Fq "MY_HARNESS_REF=$MANIFEST_REF ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh" README.md || fail "README Bash pinned upgrade example must use $MANIFEST_REF"
grep -Fq "\$env:MY_HARNESS_REF = \"$MANIFEST_REF\"" README.md || fail "README PowerShell pinned upgrade example must use $MANIFEST_REF"
grep -Fq "### $MANIFEST_REF" README.md || fail "README version history must contain $MANIFEST_REF"

required_skills=(
  "my-harness"
  "my-harness-next-action"
  "my-harness-writing-design"
  "my-harness-autopilot-slice"
  "my-harness-upgrade"
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
