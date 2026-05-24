# My Harness

`my-harness` is a Codex plugin that packages a personal delivery harness for project work. It coordinates a gstack + Superpowers + Pencil + browser verification + Git workflow and turns the process into reusable skills.

The plugin is intentionally small and composable: each skill has one job, explicit evidence rules, and a clear output contract.

## Skills

| Skill | Purpose |
|---|---|
| `my-harness` | Router skill for choosing the right harness helper. |
| `my-harness-next-action` | Reads project evidence, classifies the current SOP step, prints a full 15-step status table, and gives a copyable next prompt. |
| `my-harness-writing-design` | Creates project design governance: `DESIGN.md`, `design/`, a Pencil starter, and `AGENTS.md` links. |
| `my-harness-autopilot-slice` | Runs a small, clearly bounded version slice through the SOP after office-hours is finalized, stopping at human handoff gates. |

## Canonical SOP

1. gstack `/office-hours`
2. gstack `/plan-design-review`
3. Pencil prototype
4. gstack `/plan-design-review` on prototype
5. gstack `/plan-eng-review`
6. Superpowers `writing-plans`
7. Superpowers `executing-plans` or `subagent-driven-development`
8. Superpowers `verification-before-completion`
9. gstack `/browse` verification, with `open-gstack-browser` when visible real-time browser control is needed and Playwright as scripted fallback/regression coverage
10. gstack `/design-review`
11. gstack `/qa`
12. gstack `/review`
13. Git closeout
14. gstack `/ship`
15. gstack `/land-and-deploy`

## Design Decisions Captured

- Skill names use the `my-harness-*` prefix so they remain clearly owned by this plugin.
- `my-harness-next-action` must be table-first, use emoji state markers, and never restart office-hours when the SOP is already closed.
- The recommended prompt from `my-harness-next-action` must be in a standalone fenced `text` block for one-action copy.
- `my-harness-writing-design` may call Pencil and Ant Design related skills/tools when available, but must not blindly generate or approve visual design.
- `my-harness-autopilot-slice` is only for small, bounded slices after office-hours is finalized. It loops `design-review`, `qa`, and `review` up to 10 times, then hands off to a human if unresolved.
- Completion, refusal, and handoff from autopilot must include a per-step summary and loop metrics.

## Local Install

From this repository:

```bash
./scripts/install-local.sh
```

The script installs the plugin into:

```text
~/.codex/plugins/local/my-harness/plugins/my-harness
```

It also writes the local marketplace file and creates global skill symlinks under:

```text
~/.codex/skills/
```

If your Codex config does not already enable this plugin, add:

```toml
[plugins."my-harness@my-harness"]
enabled = true

[marketplaces.my-harness]
source = "/Users/wenzhewang/.codex/plugins/local/my-harness"
```

For another machine, adjust the marketplace path to that user's `$CODEX_HOME`.

## Verification

Run:

```bash
./scripts/verify.sh
```

The verification script checks:

- plugin manifest JSON and required fields
- required skill directories
- skill frontmatter names matching directory names
- `Use when` descriptions
- no checked-in `__pycache__` or `.pyc` artifacts

## Development

This repository is the source of truth. Do not edit the installed copy directly except for temporary local experiments. After changing source files here, run:

```bash
./scripts/verify.sh
./scripts/install-local.sh
```

Then start a fresh Codex session or reload skill discovery if needed.

When adding a new harness helper:

1. Create `skills/my-harness-<verb>-<object>/SKILL.md`.
2. Update `skills/my-harness/SKILL.md` routing.
3. Update this README skill table.
4. Add any helper scripts/templates inside that skill directory.
5. Run `./scripts/verify.sh`.

## Repository Layout

```text
.codex-plugin/plugin.json
skills/
  my-harness/
  my-harness-next-action/
  my-harness-writing-design/
  my-harness-autopilot-slice/
docs/
scripts/
```

## License

MIT
