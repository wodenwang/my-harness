---
name: my-harness-upgrade
description: Use when updating the local my-harness Codex plugin from GitHub, checking current versus target plugin versions, pinning a release tag or branch, or verifying that my-harness skills were refreshed online
---

# My Harness Upgrade

## Purpose

Update the installed `my-harness` plugin from its GitHub source while making the version iteration explicit.

This skill coordinates the upgrade. The actual file replacement must use the bundled `scripts/upgrade.sh` so the process stays deterministic and verifiable.

## Version Model

- Local installed version: read from `~/.codex/plugins/local/my-harness/plugins/my-harness/.codex-plugin/plugin.json`.
- Source checkout version: read from this repository's `.codex-plugin/plugin.json` when maintaining the plugin.
- Target ref: the GitHub tag, branch, or commit selected for update.
- Target version: read from the downloaded target archive's `.codex-plugin/plugin.json`.
- Changelog source: `CHANGELOG.md` section matching the target version.

Default target policy:

- If the user does not specify a target, use the latest GitHub Release or newest tag resolved by `scripts/upgrade.sh`.
- If the user asks for preview, latest check, or version comparison, run `scripts/upgrade.sh --check`.
- If the user explicitly names `main`, a branch, tag, or commit, set `MY_HARNESS_REF=<ref>`.
- Do not silently switch from a stable release/tag to `main`.

## Required Workflow

1. Inspect current installation state:

   ```bash
   test -f ~/.codex/plugins/local/my-harness/plugins/my-harness/.codex-plugin/plugin.json
   python3 - <<'PY'
import json
from pathlib import Path
path = Path.home() / ".codex/plugins/local/my-harness/plugins/my-harness/.codex-plugin/plugin.json"
print(json.loads(path.read_text())["version"])
PY
   ```

2. Show the user the planned version iteration before applying changes:

   ```bash
   ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh --check
   ```

   If the install shape is different, locate the installed plugin root from the symlink:

   ```bash
   realpath ~/.codex/skills/my-harness-upgrade
   ```

3. If the user already asked to upgrade, apply the update after the check:

   ```bash
   ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
   ```

   For a pinned target:

   ```bash
   MY_HARNESS_REF=v1.0.1 ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
   ```

4. Verify fresh installed artifacts after the script finishes:

   ```bash
   python3 - <<'PY'
import json
from pathlib import Path
root = Path.home() / ".codex/plugins/local/my-harness/plugins/my-harness"
print(json.loads((root / ".codex-plugin/plugin.json").read_text())["version"])
PY
   ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/verify.sh
   ls -l ~/.codex/skills/my-harness*
   ```

## Output Contract

Always report:

- 当前版本：`<local version>`
- 目标 ref：`<tag/branch/commit/latest release>`
- 目标版本：`<target version>`
- 版本迭代：`<current> -> <target>` or `版本号未变化`
- 更新来源：GitHub Release/tag/branch/commit or explicit archive override
- 验证证据：`scripts/verify.sh` result and symlink readback
- 备份路径：the backup path printed by `scripts/upgrade.sh` when an update was applied

If only checking, say clearly that no files changed.

## Safety Rules

- Do not edit `~/.codex/config.toml` manually unless the script reports a failure that requires repair.
- Do not run `git push`, create tags, create GitHub Releases, or publish marketplace updates.
- Do not claim the plugin was updated until the installed manifest version and `~/.codex/skills/my-harness*` symlinks have been read back.
- If the local installed version equals the target version, tell the user it may still refresh files from the selected ref, but there is no semantic version iteration.
- If the downloaded target fails `scripts/verify.sh`, stop and keep the existing installation in place.

## Common Mistakes

- Treating `main` as the default stable channel.
- Reporting success from `curl` or `rsync` output without manifest and symlink verification.
- Updating a copied skill directory instead of the plugin source under `~/.codex/plugins/local/my-harness/plugins/my-harness`.
- Forgetting that `.codex-plugin/plugin.json` is the version source of truth.
