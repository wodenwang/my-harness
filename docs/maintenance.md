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

## Release Checklist

Before a public release:

1. Update `.codex-plugin/plugin.json` version.
2. Update `CHANGELOG.md`.
3. Run `./scripts/verify.sh`.
4. Run `./scripts/install-local.sh` and smoke test in a fresh Codex session.
5. Commit the release.
6. Push only after explicit authorization.
