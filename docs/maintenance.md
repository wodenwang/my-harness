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

Step numbers are the evidence ledger. If a change introduces user-facing phase grouping or work-package language, keep the 15 canonical step rows intact and update the phase view in the same files. Do not remove or renumber steps just because adjacent steps can be executed together.

## Product Design Frontend Guidance

Product Design integration is maintained directly inside the core harness skills. There is no separate bridge skill.

Rules:

- Do not add Product Design as a required dependency for `my-harness`.
- If Product Design is unavailable, the framework must fall back to shadcn/ui design governance, existing UI references, screenshots, or optional Pencil for complex alignment.
- Keep the 15-step SOP unchanged; Product Design is used directly inside design, implementation, or visual QA stages.
- Keep Pencil optional unless a target project explicitly records a `.pen` requirement or the UI module needs human alignment.
- Step 3 is `Design artifact / visual target`, not mandatory Pencil work.
- Keep `image-to-code` / `url-to-code` behind `IMPLEMENTATION_PLAN.md`.
- Keep `design-qa.md` as supporting evidence only; it must not replace verification, `gstack /design-review`, QA, review, ship, or deploy.

When changing Product Design guidance, update:

- `skills/my-harness/SKILL.md`
- `skills/my-harness-next-action/SKILL.md`
- `skills/my-harness-writing-design/SKILL.md`
- `skills/my-harness-autopilot-slice/SKILL.md`
- `README.md`
- `docs/project-history.md`
- `CHANGELOG.md`

Then run:

```bash
./scripts/verify.sh
```

## Writing Design Scenario Guidance

`my-harness-writing-design` must choose the design baseline from the product scenario.

Rules:

- If product scenario is unclear, do not initialize files. Ask the user to choose Admin Console, BI dashboard/data cockpit, or C-end website/app.
- Admin Console / backend management uses shadcn/ui + tweakcn.
- BI chart analysis / analytics dashboard / data cockpit uses React + Ant Design Pro + ECharts.
- C-end website/app does not lock a frontend framework in `writing-design`; Product Design output feeds the later `plan-eng-review` framework decision.
- Ant Design Pro is supported here only for BI/data cockpit scenarios, not normal Admin Console work.

When changing scenario guidance, update:

- `skills/my-harness-writing-design/SKILL.md`
- `skills/my-harness-writing-design/scripts/harness_write_design.py`
- `skills/my-harness-writing-design/templates/`
- `skills/my-harness-next-action/SKILL.md`
- `skills/my-harness/SKILL.md`
- `README.md`
- `docs/project-history.md`
- `CHANGELOG.md`

Then run:

```bash
./scripts/verify.sh
```

## shadcn MCP Guidance

shadcn MCP is an important optional helper for shadcn/ui frontend work. Maintain it as a recommended tool, not a hard dependency.

Rules:

- Do not block the `my-harness` SOP when shadcn MCP is unavailable.
- Fall back to shadcn CLI, official shadcn docs, and existing project components.
- Do not silently edit global Codex MCP configuration; adding shadcn MCP to `~/.codex/config.toml` requires explicit user authorization.
- Keep component discovery and install work behind the normal gates: design component mapping, `plan-eng-review`, `IMPLEMENTATION_PLAN.md`, implementation, and design review.
- Generated or installed registry code must still be inspected for dependencies, tokens, accessibility, responsive behavior, and project conventions.

When changing shadcn MCP guidance, update:

- `skills/my-harness-writing-design/SKILL.md`
- `skills/my-harness-writing-design/templates/DESIGN.shadcn-admin-console.md`
- `skills/my-harness-next-action/SKILL.md`
- `skills/my-harness/SKILL.md`
- `README.md`
- `docs/project-history.md`
- `CHANGELOG.md`

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
$env:MY_HARNESS_REF = "v1.4.0"
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1"
```

After an update, always verify:

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/verify.sh
ls -l ~/.codex/skills/my-harness*
```

## Project Initialization Workflow

New or mostly empty target projects are initialized through `my-harness-initialize-project`.

Use it to create or strengthen the first project-facing governance surface:

- `README.md` with purpose, status, and local/verification placeholders when unknown
- `AGENTS.md` with agent rules, verification expectations, and no unauthorized release/push/deploy actions
- links to `DESIGN.md` and `DEPLOY.md` when those governance files are created or already present
- a final handoff to `my-harness-next-action`

Keep this separate from implementation work. The initializer must not invent a stack, create secrets, or build the app unless the user explicitly asks for implementation.

## Project Deploy / Upgrade Workflow

Project-level production deployment governance is handled by `my-harness-writing-deployment`.

Use it for target projects that need:

- versioned Docker images as the release artifact
- Docker Compose as the production runtime
- `install.sh` for first-time initialization
- `upgrade.sh` for version-to-version upgrades
- DB initialization SQL for first install when Compose includes a DB container
- DB DDL/data migration SQL or a mature migration tool for every release gap
- runtime configuration migration checks during upgrade

The skill writes or preserves `DEPLOY.md`, then links the deployment constraint from `AGENTS.md` and `CLAUDE.md`. Keep this separate from `my-harness-upgrade`, which only updates the local `my-harness` plugin installation.

The generated governance must also require strict `DEPLOY.md` compliance during development and final deployment, require missing `install.sh` / `upgrade.sh` scripts to be developed, and require both install and upgrade logic to be validated for every version upgrade and release.

## Optional Post-Deploy Canary Workflow

Post-deploy canary monitoring is handled by `my-harness-canary`.

Use it after step 15 when a target project needs extra confidence on a live production, staging, or preview URL. Keep it separate from `land-and-deploy`: the required SOP still has 15 steps, and canary is an optional direct-call follow-up.

The skill wraps gstack `/canary` and must stay observational:

- save canary report evidence under `.gstack/canary-reports/` when available
- create GitHub issues for confirmed findings in the monitored project
- do not modify code, tests, deployment files, docs, or runtime config to fix findings
- confirm the target GitHub repo when it cannot be resolved unambiguously
- support explicit user requests for daily or periodic Codex automation, but never start recurring checks by default

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
