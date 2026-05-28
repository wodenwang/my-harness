# Maintenance Guide

## Add A Skill

1. Create `skills/my-harness-<verb>-<object>/SKILL.md`.
2. Add frontmatter:

   ```markdown
   ---
   name: my-harness-<verb>-<object>
   description: Use when ...
   ---
   ```

3. Include:
   - purpose
   - when to use
   - evidence or inputs to inspect
   - exact output shape
   - write/edit safety rules
   - completion checks
   - common mistakes
4. Update `skills/my-harness/SKILL.md`.
5. Update `README.md`.
6. Run `./scripts/verify.sh`.
7. Run `./scripts/install-local.sh` before local dogfooding.

## Update SOP Steps

When changing the canonical harness flow, update all of these files in the same change:

- `README.md`
- `AGENTS.md`
- `docs/project-history.md`
- `skills/my-harness/SKILL.md`
- `skills/my-harness-next-action/SKILL.md`
- `skills/my-harness-autopilot-slice/SKILL.md`

Then run:

```bash
./scripts/verify.sh
```

## Local Dogfooding

Use the source repo as the edit point:

```bash
cd /Users/wenzhewang/my_plugin/my-harness
./scripts/verify.sh
./scripts/install-local.sh
```

After installation, confirm the symlinks:

```bash
ls -l ~/.codex/skills/my-harness*
```

## Upgrade Workflow

Online updates are handled by `my-harness-upgrade` plus the platform script:

- macOS / Linux: `scripts/upgrade.sh`
- Windows PowerShell: `scripts/upgrade.ps1`

Version terms must stay consistent:

- Current version: installed plugin `.codex-plugin/plugin.json`.
- Target ref: GitHub tag, branch, or commit; omitted means latest GitHub Release/tag.
- Target version: downloaded target archive `.codex-plugin/plugin.json`.
- Version iteration: current version to target version.

Check without changing local files:

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh --check
```

Apply the latest stable update:

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

Apply a pinned update:

```bash
MY_HARNESS_REF=<tag-or-branch> ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

Windows PowerShell examples:

```powershell
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1" -Check
$env:MY_HARNESS_REF = "v1.0.5"
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1"
```

After an update, always verify:

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/verify.sh
ls -l ~/.codex/skills/my-harness*
```

## Release Checklist

Before a public release:

1. Update `.codex-plugin/plugin.json` version.
2. Update `CHANGELOG.md`.
3. Update `README.md`, including dependencies, constraints, install methods, skill usage, and version history.
4. Check `scripts/install.sh` and `scripts/install.ps1` default to the intended public ref.
5. Run `./scripts/check-release-lineage.sh --pre-release`.
6. Check `scripts/upgrade.sh --check` and `scripts/upgrade.ps1 -Check` report the expected current and target version terms where the platform is available.
7. Run `./scripts/verify.sh`.
8. Run `./scripts/install-local.sh` and smoke test in a fresh Codex session.
9. Run a temporary-home installer smoke test:

   ```bash
   CODEX_HOME="$(mktemp -d)" MY_HARNESS_REF=<tag-or-branch> bash scripts/install.sh
   ```

10. Run a temporary-home upgrade smoke test against the intended archive or ref.
11. Commit the release.
12. Push, tag, and create GitHub Release only after explicit authorization.
13. Run `./scripts/check-release-lineage.sh --post-release`.
